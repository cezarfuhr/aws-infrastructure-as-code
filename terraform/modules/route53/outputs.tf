output "hosted_zone_id" {
  description = "ID da hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].zone_id : null
}

output "hosted_zone_name_servers" {
  description = "Name servers da hosted zone"
  value       = var.create_hosted_zone ? aws_route53_zone.main[0].name_servers : []
}

output "certificate_arn" {
  description = "ARN do certificado ACM"
  value       = var.create_certificate ? aws_acm_certificate.main[0].arn : null
}

output "certificate_domain_validation_options" {
  description = "Opções de validação do certificado"
  value       = var.create_certificate ? aws_acm_certificate.main[0].domain_validation_options : []
}

output "cloudfront_certificate_arn" {
  description = "ARN do certificado CloudFront"
  value       = var.create_cloudfront_certificate ? aws_acm_certificate.cloudfront[0].arn : null
}

output "alb_fqdn" {
  description = "FQDN completo do ALB"
  value       = var.create_hosted_zone && var.alb_dns_name != "" ? aws_route53_record.alb[0].fqdn : null
}

output "cloudfront_fqdn" {
  description = "FQDN completo do CloudFront"
  value       = var.create_hosted_zone && var.cloudfront_domain_name != "" ? aws_route53_record.cloudfront[0].fqdn : null
}

output "api_fqdn" {
  description = "FQDN do subdomínio API"
  value       = var.create_hosted_zone && var.create_api_subdomain ? aws_route53_record.api[0].fqdn : null
}

output "health_check_id" {
  description = "ID do health check"
  value       = var.enable_health_checks ? aws_route53_health_check.alb[0].id : null
}
