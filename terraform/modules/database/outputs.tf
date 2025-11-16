output "db_instance_id" {
  description = "ID da instância RDS"
  value       = aws_db_instance.main.id
}

output "db_instance_endpoint" {
  description = "Endpoint da instância RDS"
  value       = aws_db_instance.main.endpoint
}

output "db_instance_address" {
  description = "Endereço da instância RDS"
  value       = aws_db_instance.main.address
}

output "db_instance_port" {
  description = "Porta da instância RDS"
  value       = aws_db_instance.main.port
}

output "db_instance_arn" {
  description = "ARN da instância RDS"
  value       = aws_db_instance.main.arn
}

output "db_name" {
  description = "Nome do banco de dados"
  value       = aws_db_instance.main.db_name
}

output "db_username" {
  description = "Username do banco de dados"
  value       = aws_db_instance.main.username
  sensitive   = true
}

output "db_secret_arn" {
  description = "ARN do secret com credenciais do banco"
  value       = aws_secretsmanager_secret.db_password.arn
}

output "db_subnet_group_id" {
  description = "ID do DB subnet group"
  value       = aws_db_subnet_group.main.id
}

output "db_parameter_group_id" {
  description = "ID do DB parameter group"
  value       = aws_db_parameter_group.main.id
}

output "replica_endpoint" {
  description = "Endpoint da read replica"
  value       = var.create_read_replica ? aws_db_instance.replica[0].endpoint : null
}
