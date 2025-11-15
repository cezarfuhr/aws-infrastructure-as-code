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
