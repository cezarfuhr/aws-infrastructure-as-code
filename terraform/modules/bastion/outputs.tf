output "session_manager_policy_arn" {
  description = "ARN da policy do Session Manager"
  value       = aws_iam_policy.session_manager.arn
}

output "s3_bucket_name" {
  description = "Nome do bucket S3 para session logs"
  value       = var.enable_session_logging ? aws_s3_bucket.session_logs[0].id : null
}

output "s3_bucket_arn" {
  description = "ARN do bucket S3 para session logs"
  value       = var.enable_session_logging ? aws_s3_bucket.session_logs[0].arn : null
}

output "cloudwatch_log_group_name" {
  description = "Nome do log group CloudWatch"
  value       = var.enable_cloudwatch_logging ? aws_cloudwatch_log_group.session_logs[0].name : null
}

output "cloudwatch_log_group_arn" {
  description = "ARN do log group CloudWatch"
  value       = var.enable_cloudwatch_logging ? aws_cloudwatch_log_group.session_logs[0].arn : null
}

output "kms_key_id" {
  description = "ID da chave KMS"
  value       = var.enable_kms_encryption ? aws_kms_key.session_manager[0].key_id : null
}

output "kms_key_arn" {
  description = "ARN da chave KMS"
  value       = var.enable_kms_encryption ? aws_kms_key.session_manager[0].arn : null
}

output "ssm_document_name" {
  description = "Nome do SSM document"
  value       = aws_ssm_document.session_manager_prefs.name
}

output "bastion_security_group_id" {
  description = "ID do security group do bastion"
  value       = var.create_bastion_security_group ? aws_security_group.bastion[0].id : null
}

output "connection_command" {
  description = "Comando para conectar via Session Manager"
  value       = "aws ssm start-session --target <instance-id>"
}
