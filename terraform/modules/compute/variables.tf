variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs das subnets públicas para o ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas para as instâncias EC2"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "ID do security group do ALB"
  type        = string
}

variable "web_security_group_id" {
  description = "ID do security group para instâncias web"
  type        = string
}

variable "instance_profile_name" {
  description = "Nome do instance profile IAM"
  type        = string
}

variable "ami_id" {
  description = "ID da AMI para as instâncias EC2"
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Nome da chave SSH"
  type        = string
  default     = ""
}

variable "min_size" {
  description = "Número mínimo de instâncias no ASG"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Número máximo de instâncias no ASG"
  type        = number
  default     = 4
}

variable "desired_capacity" {
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
  description = "ARN do certificado SSL/TLS"
  type        = string
  default     = ""
}

variable "enable_deletion_protection" {
  description = "Habilitar proteção contra deleção do ALB"
  type        = bool
  default     = false
}

variable "root_volume_size" {
  description = "Tamanho do volume root em GB"
  type        = number
  default     = 20
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}
