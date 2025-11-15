output "web_acl_id" {
  description = "ID do Web ACL"
  value       = aws_wafv2_web_acl.main.id
}

output "web_acl_arn" {
  description = "ARN do Web ACL"
  value       = aws_wafv2_web_acl.main.arn
}

output "web_acl_capacity" {
  description = "Capacidade utilizada pelo Web ACL"
  value       = aws_wafv2_web_acl.main.capacity
}

output "log_group_name" {
  description = "Nome do log group do WAF"
  value       = var.enable_logging ? aws_cloudwatch_log_group.waf[0].name : null
}

output "ip_whitelist_arn" {
  description = "ARN do IP set whitelist"
  value       = var.enable_ip_whitelist ? aws_wafv2_ip_set.whitelist[0].arn : null
}

output "ip_blacklist_arn" {
  description = "ARN do IP set blacklist"
  value       = var.enable_ip_blacklist ? aws_wafv2_ip_set.blacklist[0].arn : null
}
