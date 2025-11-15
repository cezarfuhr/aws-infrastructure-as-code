output "trail_arn" {
  description = "ARN do CloudTrail"
  value       = aws_cloudtrail.main.arn
}

output "trail_id" {
  description = "ID do CloudTrail"
  value       = aws_cloudtrail.main.id
}

output "s3_bucket_name" {
  description = "Nome do bucket S3 para logs"
  value       = aws_s3_bucket.cloudtrail.id
}

output "s3_bucket_arn" {
  description = "ARN do bucket S3 para logs"
  value       = aws_s3_bucket.cloudtrail.arn
}

output "kms_key_id" {
  description = "ID da chave KMS"
  value       = var.enable_kms_encryption ? aws_kms_key.cloudtrail[0].key_id : null
}

output "kms_key_arn" {
  description = "ARN da chave KMS"
  value       = var.enable_kms_encryption ? aws_kms_key.cloudtrail[0].arn : null
}

output "cloudwatch_log_group_name" {
  description = "Nome do log group CloudWatch"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.cloudtrail[0].name : null
}

output "cloudwatch_log_group_arn" {
  description = "ARN do log group CloudWatch"
  value       = var.enable_cloudwatch_logs ? aws_cloudwatch_log_group.cloudtrail[0].arn : null
}

output "sns_topic_arn" {
  description = "ARN do SNS topic"
  value       = var.enable_sns_notifications ? aws_sns_topic.cloudtrail[0].arn : null
}
