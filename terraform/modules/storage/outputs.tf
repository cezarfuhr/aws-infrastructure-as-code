output "assets_bucket_id" {
  description = "ID do bucket S3 de assets"
  value       = aws_s3_bucket.assets.id
}

output "assets_bucket_arn" {
  description = "ARN do bucket S3 de assets"
  value       = aws_s3_bucket.assets.arn
}

output "assets_bucket_domain_name" {
  description = "Domain name do bucket S3 de assets"
  value       = aws_s3_bucket.assets.bucket_domain_name
}

output "logs_bucket_id" {
  description = "ID do bucket S3 de logs"
  value       = aws_s3_bucket.logs.id
}

output "logs_bucket_arn" {
  description = "ARN do bucket S3 de logs"
  value       = aws_s3_bucket.logs.arn
}

output "cloudfront_distribution_id" {
  description = "ID da distribuição CloudFront"
  value       = aws_cloudfront_distribution.main.id
}

output "cloudfront_distribution_arn" {
  description = "ARN da distribuição CloudFront"
  value       = aws_cloudfront_distribution.main.arn
}

output "cloudfront_domain_name" {
  description = "Domain name da distribuição CloudFront"
  value       = aws_cloudfront_distribution.main.domain_name
}

output "cloudfront_hosted_zone_id" {
  description = "Hosted zone ID da distribuição CloudFront"
  value       = aws_cloudfront_distribution.main.hosted_zone_id
}
