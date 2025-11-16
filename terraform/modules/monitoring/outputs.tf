output "sns_topic_arn" {
  description = "ARN do SNS topic para alarmes"
  value       = aws_sns_topic.alarms.arn
}

output "cloudwatch_log_group_name" {
  description = "Nome do log group do CloudWatch"
  value       = aws_cloudwatch_log_group.application.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN do log group do CloudWatch"
  value       = aws_cloudwatch_log_group.application.arn
}

output "dashboard_name" {
  description = "Nome do dashboard do CloudWatch"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}
