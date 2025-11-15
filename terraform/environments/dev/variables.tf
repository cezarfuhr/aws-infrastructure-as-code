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
