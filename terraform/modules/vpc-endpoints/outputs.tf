output "security_group_id" {
  description = "ID do security group dos VPC endpoints"
  value       = aws_security_group.vpc_endpoints.id
}

output "s3_endpoint_id" {
  description = "ID do S3 endpoint"
  value       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].id : null
}

output "dynamodb_endpoint_id" {
  description = "ID do DynamoDB endpoint"
  value       = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].id : null
}

output "ssm_endpoint_ids" {
  description = "IDs dos SSM endpoints"
  value = var.enable_ssm_endpoints ? {
    ssm          = aws_vpc_endpoint.ssm[0].id
    ec2messages  = aws_vpc_endpoint.ec2messages[0].id
    ssmmessages  = aws_vpc_endpoint.ssmmessages[0].id
  } : null
}

output "logs_endpoint_id" {
  description = "ID do CloudWatch Logs endpoint"
  value       = var.enable_logs_endpoint ? aws_vpc_endpoint.logs[0].id : null
}

output "monitoring_endpoint_id" {
  description = "ID do CloudWatch Monitoring endpoint"
  value       = var.enable_monitoring_endpoint ? aws_vpc_endpoint.monitoring[0].id : null
}

output "secretsmanager_endpoint_id" {
  description = "ID do Secrets Manager endpoint"
  value       = var.enable_secretsmanager_endpoint ? aws_vpc_endpoint.secretsmanager[0].id : null
}

output "cost_savings_estimate" {
  description = "Estimativa de economia mensal com VPC endpoints (USD)"
  value = <<-EOT
    Estimativa de economia com VPC Endpoints:
    - NAT Gateway eliminado: ~$32/mês por AZ
    - Transfer costs reduzidos: ~$50-100/mês (dependendo do tráfego)
    - Custo dos Interface Endpoints: ~$7.20/mês por endpoint
    - Gateway Endpoints (S3, DynamoDB): Grátis

    Com ${var.enable_s3_endpoint ? 1 : 0} gateway endpoints e aproximadamente ${
      (var.enable_ssm_endpoints ? 3 : 0) +
      (var.enable_logs_endpoint ? 1 : 0) +
      (var.enable_monitoring_endpoint ? 1 : 0) +
      (var.enable_secretsmanager_endpoint ? 1 : 0)
    } interface endpoints:
    - Custo estimado de endpoints: $${
      ((var.enable_ssm_endpoints ? 3 : 0) +
      (var.enable_logs_endpoint ? 1 : 0) +
      (var.enable_monitoring_endpoint ? 1 : 0) +
      (var.enable_secretsmanager_endpoint ? 1 : 0)) * 7.20
    }/mês
    - Economia potencial: Varia conforme uso
  EOT
}
