output "alb_security_group_id" {
  description = "ID do security group do ALB"
  value       = aws_security_group.alb.id
}

output "web_security_group_id" {
  description = "ID do security group dos servidores web"
  value       = aws_security_group.web.id
}

output "database_security_group_id" {
  description = "ID do security group do banco de dados"
  value       = aws_security_group.database.id
}

output "ec2_iam_role_arn" {
  description = "ARN do IAM role para EC2"
  value       = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_name" {
  description = "Nome do instance profile para EC2"
  value       = aws_iam_instance_profile.ec2_profile.name
}

output "ec2_instance_profile_arn" {
  description = "ARN do instance profile para EC2"
  value       = aws_iam_instance_profile.ec2_profile.arn
}
