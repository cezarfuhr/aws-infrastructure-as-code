# General Variables
variable "project_name" {
  description = "Nome do projeto"
  type        = string
  default     = "aws-infra"
}

variable "environment" {
  description = "Ambiente"
  type        = string
  default     = "prod"
}

variable "aws_region" {
  description = "Região AWS"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  description = "Tags adicionais para recursos"
  type        = map(string)
  default     = {}
}

# VPC Variables
variable "vpc_cidr" {
  description = "CIDR block para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Lista de CIDR blocks para subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Lista de CIDR blocks para subnets privadas"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.11.0/24"]
}

variable "enable_nat_gateway" {
  description = "Habilitar NAT Gateway"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Habilitar VPC Flow Logs"
  type        = bool
  default     = true
}

# Security Variables
variable "ssh_allowed_cidr_blocks" {
  description = "Lista de CIDR blocks permitidos para SSH"
  type        = list(string)
  default     = []
}

# Compute Variables
variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "Nome da chave SSH"
  type        = string
  default     = ""
}

variable "asg_min_size" {
  description = "Número mínimo de instâncias no ASG"
  type        = number
  default     = 2
}

variable "asg_max_size" {
  description = "Número máximo de instâncias no ASG"
  type        = number
  default     = 6
}

variable "asg_desired_capacity" {
  description = "Capacidade desejada do ASG"
  type        = number
  default     = 2
}

variable "app_port" {
  description = "Porta da aplicação"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "Path para health check"
  type        = string
  default     = "/health"
}

variable "certificate_arn" {
  description = "ARN do certificado SSL/TLS para o ALB"
  type        = string
  default     = ""
}

variable "enable_alb_deletion_protection" {
  description = "Habilitar proteção contra deleção do ALB"
  type        = bool
  default     = true
}

# Database Variables
variable "db_engine" {
  description = "Engine do banco de dados"
  type        = string
  default     = "postgres"
}

variable "db_engine_version" {
  description = "Versão do engine do banco de dados"
  type        = string
  default     = "15.4"
}

variable "db_instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.small"
}

variable "db_allocated_storage" {
  description = "Storage alocado em GB"
  type        = number
  default     = 50
}

variable "db_max_allocated_storage" {
  description = "Máximo de storage para autoscaling em GB"
  type        = number
  default     = 200
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Username do banco de dados"
  type        = string
  default     = "admin"
}

variable "db_multi_az" {
  description = "Habilitar Multi-AZ deployment"
  type        = bool
  default     = true
}

variable "db_backup_retention_period" {
  description = "Período de retenção de backups em dias"
  type        = number
  default     = 30
}

variable "db_deletion_protection" {
  description = "Habilitar proteção contra deleção"
  type        = bool
  default     = true
}

variable "db_enable_performance_insights" {
  description = "Habilitar Performance Insights"
  type        = bool
  default     = true
}

variable "db_parameter_group_family" {
  description = "Família do parameter group"
  type        = string
  default     = "postgres15"
}

variable "db_create_read_replica" {
  description = "Criar read replica"
  type        = bool
  default     = false
}

# Storage Variables
variable "s3_enable_versioning" {
  description = "Habilitar versionamento do S3"
  type        = bool
  default     = true
}

variable "s3_enable_lifecycle_rules" {
  description = "Habilitar regras de lifecycle"
  type        = bool
  default     = true
}

variable "cloudfront_default_root_object" {
  description = "Objeto root padrão do CloudFront"
  type        = string
  default     = "index.html"
}

variable "cloudfront_price_class" {
  description = "Price class do CloudFront"
  type        = string
  default     = "PriceClass_All"
}

variable "cloudfront_domain_aliases" {
  description = "Lista de aliases de domínio para CloudFront"
  type        = list(string)
  default     = []
}

variable "cloudfront_acm_certificate_arn" {
  description = "ARN do certificado ACM para CloudFront"
  type        = string
  default     = ""
}

# Monitoring Variables
variable "alarm_email_endpoints" {
  description = "Lista de emails para receber notificações de alarmes"
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "Dias de retenção para logs do CloudWatch"
  type        = number
  default     = 90
}

# VPC Endpoints Variables
variable "enable_s3_endpoint" {
  description = "Habilitar S3 endpoint"
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Habilitar DynamoDB endpoint"
  type        = bool
  default     = false
}

variable "enable_ssm_endpoints" {
  description = "Habilitar SSM endpoints para Session Manager"
  type        = bool
  default     = true
}

variable "enable_logs_endpoint" {
  description = "Habilitar CloudWatch Logs endpoint"
  type        = bool
  default     = true
}

variable "enable_monitoring_endpoint" {
  description = "Habilitar CloudWatch Monitoring endpoint"
  type        = bool
  default     = true
}

variable "enable_secretsmanager_endpoint" {
  description = "Habilitar Secrets Manager endpoint"
  type        = bool
  default     = true
}

variable "enable_kms_endpoint" {
  description = "Habilitar KMS endpoint"
  type        = bool
  default     = false
}

# Session Manager/Bastion Variables
variable "enable_session_logging" {
  description = "Habilitar logging de sessões Session Manager"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_logging" {
  description = "Habilitar CloudWatch logging para Session Manager"
  type        = bool
  default     = true
}

variable "enable_kms_encryption" {
  description = "Habilitar KMS encryption"
  type        = bool
  default     = true
}

# CloudTrail Variables
variable "cloudtrail_multi_region" {
  description = "Habilitar CloudTrail multi-region"
  type        = bool
  default     = true
}

variable "cloudtrail_enable_kms" {
  description = "Habilitar KMS encryption no CloudTrail"
  type        = bool
  default     = true
}

variable "cloudtrail_enable_cloudwatch" {
  description = "Enviar CloudTrail logs para CloudWatch"
  type        = bool
  default     = true
}

variable "cloudtrail_enable_data_events" {
  description = "Habilitar data events no CloudTrail"
  type        = bool
  default     = false
}

variable "cloudtrail_enable_insights" {
  description = "Habilitar CloudTrail Insights"
  type        = bool
  default     = false
}

variable "cloudtrail_enable_security_alarms" {
  description = "Habilitar alarmes de segurança"
  type        = bool
  default     = true
}

# WAF Variables
variable "waf_rate_limit" {
  description = "Rate limit do WAF (requisições por 5 minutos)"
  type        = number
  default     = 2000
}

variable "waf_enable_ip_reputation" {
  description = "Habilitar IP reputation list"
  type        = bool
  default     = true
}

variable "waf_enable_bot_control" {
  description = "Habilitar bot control (custo adicional)"
  type        = bool
  default     = false
}

variable "waf_enable_geo_blocking" {
  description = "Habilitar bloqueio geográfico"
  type        = bool
  default     = false
}

variable "waf_blocked_countries" {
  description = "Lista de países bloqueados"
  type        = list(string)
  default     = []
}

# Route 53 Variables
variable "create_route53_zone" {
  description = "Criar hosted zone do Route53"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Nome do domínio"
  type        = string
  default     = ""
}

variable "create_route53_certificate" {
  description = "Criar certificado ACM via Route53"
  type        = bool
  default     = false
}

variable "create_cloudfront_certificate" {
  description = "Criar certificado CloudFront"
  type        = bool
  default     = false
}

variable "certificate_sans" {
  description = "Subject Alternative Names para certificado"
  type        = list(string)
  default     = []
}

variable "route53_enable_health_checks" {
  description = "Habilitar health checks Route53"
  type        = bool
  default     = true
}
