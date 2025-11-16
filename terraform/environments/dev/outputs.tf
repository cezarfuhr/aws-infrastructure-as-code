# VPC Outputs
output "vpc_id" {
  description = "ID da VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "IDs das subnets públicas"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "IDs das subnets privadas"
  value       = module.vpc.private_subnet_ids
}

# Compute Outputs
output "alb_dns_name" {
  description = "DNS name do Application Load Balancer"
  value       = module.compute.alb_dns_name
}

output "alb_zone_id" {
  description = "Zone ID do Application Load Balancer"
  value       = module.compute.alb_zone_id
}

output "autoscaling_group_name" {
  description = "Nome do Auto Scaling Group"
  value       = module.compute.autoscaling_group_name
}

# Database Outputs
output "db_instance_endpoint" {
  description = "Endpoint da instância RDS"
  value       = module.database.db_instance_endpoint
}

output "db_instance_address" {
  description = "Endereço da instância RDS"
  value       = module.database.db_instance_address
}

output "db_secret_arn" {
  description = "ARN do secret com credenciais do banco"
  value       = module.database.db_secret_arn
}

# Storage Outputs
output "assets_bucket_id" {
  description = "ID do bucket S3 de assets"
  value       = module.storage.assets_bucket_id
}

output "cloudfront_domain_name" {
  description = "Domain name da distribuição CloudFront"
  value       = module.storage.cloudfront_domain_name
}

output "cloudfront_distribution_id" {
  description = "ID da distribuição CloudFront"
  value       = module.storage.cloudfront_distribution_id
}

# Monitoring Outputs
output "cloudwatch_dashboard_name" {
  description = "Nome do dashboard do CloudWatch"
  value       = module.monitoring.dashboard_name
}

output "sns_topic_arn" {
  description = "ARN do SNS topic para alarmes"
  value       = module.monitoring.sns_topic_arn
}

# Useful Commands
output "useful_commands" {
  description = "Comandos úteis para gerenciar a infraestrutura"
  value = <<-EOT

    ===== Comandos Úteis =====

    1. Acessar o Load Balancer:
       http://${module.compute.alb_dns_name}

    2. Acessar CloudFront CDN:
       https://${module.storage.cloudfront_domain_name}

    3. Ver logs da aplicação:
       aws logs tail ${module.monitoring.cloudwatch_log_group_name} --follow

    4. Obter senha do banco de dados:
       aws secretsmanager get-secret-value --secret-id ${module.database.db_secret_arn} --query SecretString --output text

    5. Invalidar cache do CloudFront:
       aws cloudfront create-invalidation --distribution-id ${module.storage.cloudfront_distribution_id} --paths "/*"

    6. Ver dashboard do CloudWatch:
       https://console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards:name=${module.monitoring.dashboard_name}

  EOT
}

# VPC Endpoints Outputs
output "vpc_endpoints_security_group_id" {
  description = "ID do security group dos VPC endpoints"
  value       = module.vpc_endpoints.security_group_id
}

output "s3_endpoint_id" {
  description = "ID do S3 endpoint"
  value       = module.vpc_endpoints.s3_endpoint_id
}

output "vpc_endpoints_cost_estimate" {
  description = "Estimativa de custo dos VPC endpoints"
  value       = module.vpc_endpoints.cost_savings_estimate
}

# Session Manager Outputs
output "session_manager_connection_command" {
  description = "Comando para conectar via Session Manager"
  value       = module.bastion.connection_command
}

output "session_logs_bucket" {
  description = "Bucket S3 para session logs"
  value       = module.bastion.s3_bucket_name
}

# CloudTrail Outputs
output "cloudtrail_arn" {
  description = "ARN do CloudTrail"
  value       = module.cloudtrail.trail_arn
}

output "cloudtrail_bucket" {
  description = "Bucket S3 do CloudTrail"
  value       = module.cloudtrail.s3_bucket_name
}

# WAF Outputs
output "waf_web_acl_id" {
  description = "ID do WAF Web ACL"
  value       = module.waf.web_acl_id
}

output "waf_web_acl_arn" {
  description = "ARN do WAF Web ACL"
  value       = module.waf.web_acl_arn
}

# Route 53 Outputs
output "route53_zone_id" {
  description = "ID da hosted zone Route53"
  value       = var.create_route53_zone ? module.route53[0].hosted_zone_id : null
}

output "route53_name_servers" {
  description = "Name servers da hosted zone"
  value       = var.create_route53_zone ? module.route53[0].hosted_zone_name_servers : []
}

output "route53_certificate_arn" {
  description = "ARN do certificado ACM"
  value       = var.create_route53_zone && var.create_route53_certificate ? module.route53[0].certificate_arn : null
}

output "domain_url" {
  description = "URL do domínio principal"
  value       = var.create_route53_zone ? "https://${var.domain_name}" : null
}

output "api_url" {
  description = "URL da API"
  value       = var.create_route53_zone ? "https://api.${var.domain_name}" : null
}

output "cdn_url" {
  description = "URL do CDN"
  value       = var.create_route53_zone ? "https://cdn.${var.domain_name}" : null
}
