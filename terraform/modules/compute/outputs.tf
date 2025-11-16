output "alb_arn" {
  description = "ARN do Application Load Balancer"
  value       = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "DNS name do Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID do Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  description = "ARN do target group"
  value       = aws_lb_target_group.main.arn
}

output "autoscaling_group_id" {
  description = "ID do Auto Scaling Group"
  value       = aws_autoscaling_group.main.id
}

output "autoscaling_group_name" {
  description = "Nome do Auto Scaling Group"
  value       = aws_autoscaling_group.main.name
}

output "launch_template_id" {
  description = "ID do Launch Template"
  value       = aws_launch_template.main.id
}

output "launch_template_latest_version" {
  description = "Última versão do Launch Template"
  value       = aws_launch_template.main.latest_version
}
