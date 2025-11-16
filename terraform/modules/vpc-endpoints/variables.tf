variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR da VPC"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas"
  type        = list(string)
}

variable "route_table_ids" {
  description = "IDs das route tables para gateway endpoints"
  type        = list(string)
}

# Gateway Endpoints (Free)
variable "enable_s3_endpoint" {
  description = "Habilitar S3 gateway endpoint"
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Habilitar DynamoDB gateway endpoint"
  type        = bool
  default     = false
}

# Interface Endpoints for Session Manager (Essential)
variable "enable_ssm_endpoints" {
  description = "Habilitar endpoints SSM para Session Manager"
  type        = bool
  default     = true
}

# Interface Endpoints for Monitoring
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

# Interface Endpoints for Secrets
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

# Interface Endpoints for EC2
variable "enable_ec2_endpoint" {
  description = "Habilitar EC2 endpoint"
  type        = bool
  default     = false
}

# Interface Endpoints for Container Services
variable "enable_ecr_endpoints" {
  description = "Habilitar ECR endpoints"
  type        = bool
  default     = false
}

variable "enable_ecs_endpoints" {
  description = "Habilitar ECS endpoints"
  type        = bool
  default     = false
}

# Interface Endpoints for Other Services
variable "enable_rds_endpoint" {
  description = "Habilitar RDS endpoint"
  type        = bool
  default     = false
}

variable "enable_sns_endpoint" {
  description = "Habilitar SNS endpoint"
  type        = bool
  default     = false
}

variable "enable_sqs_endpoint" {
  description = "Habilitar SQS endpoint"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}
