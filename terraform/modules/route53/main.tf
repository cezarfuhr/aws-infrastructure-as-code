# Route 53 Module - DNS Management

# Hosted Zone
resource "aws_route53_zone" "main" {
  count = var.create_hosted_zone ? 1 : 0
  name  = var.domain_name

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-hosted-zone"
    }
  )
}

# ALB DNS Record
resource "aws_route53_record" "alb" {
  count   = var.create_hosted_zone && var.alb_dns_name != "" ? 1 : 0
  zone_id = aws_route53_zone.main[0].zone_id
  name    = var.alb_subdomain != "" ? "${var.alb_subdomain}.${var.domain_name}" : var.domain_name
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# CloudFront DNS Record
resource "aws_route53_record" "cloudfront" {
  count   = var.create_hosted_zone && var.cloudfront_domain_name != "" ? 1 : 0
  zone_id = aws_route53_zone.main[0].zone_id
  name    = var.cloudfront_subdomain != "" ? "${var.cloudfront_subdomain}.${var.domain_name}" : "cdn.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

# API subdomain (points to ALB)
resource "aws_route53_record" "api" {
  count   = var.create_hosted_zone && var.alb_dns_name != "" && var.create_api_subdomain ? 1 : 0
  zone_id = aws_route53_zone.main[0].zone_id
  name    = "api.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# Health Check for ALB
resource "aws_route53_health_check" "alb" {
  count             = var.create_hosted_zone && var.alb_dns_name != "" && var.enable_health_checks ? 1 : 0
  fqdn              = var.alb_dns_name
  port              = 443
  type              = "HTTPS"
  resource_path     = var.health_check_path
  failure_threshold = var.health_check_failure_threshold
  request_interval  = var.health_check_interval

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-alb-health-check"
    }
  )
}

# CloudWatch Alarm for Health Check
resource "aws_cloudwatch_metric_alarm" "health_check" {
  count               = var.create_hosted_zone && var.enable_health_checks ? 1 : 0
  alarm_name          = "${var.project_name}-route53-health-check"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "2"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"
  period              = "60"
  statistic           = "Minimum"
  threshold           = "1"
  alarm_description   = "This metric monitors Route53 health check status"
  alarm_actions       = var.alarm_actions

  dimensions = {
    HealthCheckId = aws_route53_health_check.alb[0].id
  }

  tags = var.tags
}

# ACM Certificate for domain
resource "aws_acm_certificate" "main" {
  count             = var.create_certificate ? 1 : 0
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = var.subject_alternative_names

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-certificate"
    }
  )
}

# DNS Validation for ACM Certificate
resource "aws_route53_record" "cert_validation" {
  for_each = var.create_certificate && var.create_hosted_zone ? {
    for dvo in aws_acm_certificate.main[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.main[0].zone_id
}

# ACM Certificate Validation
resource "aws_acm_certificate_validation" "main" {
  count                   = var.create_certificate && var.create_hosted_zone ? 1 : 0
  certificate_arn         = aws_acm_certificate.main[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# CloudFront Certificate (must be in us-east-1)
resource "aws_acm_certificate" "cloudfront" {
  count             = var.create_certificate && var.create_cloudfront_certificate ? 1 : 0
  provider          = aws.us-east-1
  domain_name       = var.cloudfront_subdomain != "" ? "${var.cloudfront_subdomain}.${var.domain_name}" : "cdn.${var.domain_name}"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-cloudfront-certificate"
    }
  )
}

# MX Records for email (optional)
resource "aws_route53_record" "mx" {
  count   = var.create_hosted_zone && length(var.mx_records) > 0 ? 1 : 0
  zone_id = aws_route53_zone.main[0].zone_id
  name    = var.domain_name
  type    = "MX"
  ttl     = 300
  records = var.mx_records
}

# TXT Records (optional - for SPF, DKIM, etc)
resource "aws_route53_record" "txt" {
  count   = var.create_hosted_zone && length(var.txt_records) > 0 ? 1 : 0
  zone_id = aws_route53_zone.main[0].zone_id
  name    = var.domain_name
  type    = "TXT"
  ttl     = 300
  records = var.txt_records
}

# CNAME Records for custom subdomains
resource "aws_route53_record" "cname" {
  for_each = var.create_hosted_zone ? var.cname_records : {}

  zone_id = aws_route53_zone.main[0].zone_id
  name    = each.key
  type    = "CNAME"
  ttl     = 300
  records = [each.value]
}
