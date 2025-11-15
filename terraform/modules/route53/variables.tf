variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "domain_name" {
  description = "Nome do domínio principal"
  type        = string
}

variable "create_hosted_zone" {
  description = "Criar hosted zone do Route53"
  type        = bool
  default     = true
}

variable "create_certificate" {
  description = "Criar certificado ACM"
  type        = bool
  default     = true
}

variable "create_cloudfront_certificate" {
  description = "Criar certificado ACM para CloudFront (us-east-1)"
  type        = bool
  default     = false
}

variable "subject_alternative_names" {
  description = "SANs adicionais para o certificado"
  type        = list(string)
  default     = []
}

variable "alb_dns_name" {
  description = "DNS name do ALB"
  type        = string
  default     = ""
}

variable "alb_zone_id" {
  description = "Zone ID do ALB"
  type        = string
  default     = ""
}

variable "alb_subdomain" {
  description = "Subdomínio para o ALB"
  type        = string
  default     = ""
}

variable "cloudfront_domain_name" {
  description = "DNS name do CloudFront"
  type        = string
  default     = ""
}

variable "cloudfront_zone_id" {
  description = "Zone ID do CloudFront"
  type        = string
  default     = "Z2FDTNDATAQYW2"
}

variable "cloudfront_subdomain" {
  description = "Subdomínio para o CloudFront"
  type        = string
  default     = "cdn"
}

variable "create_api_subdomain" {
  description = "Criar subdomínio api."
  type        = bool
  default     = true
}

variable "enable_health_checks" {
  description = "Habilitar health checks do Route53"
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "Path para health check"
  type        = string
  default     = "/health"
}

variable "health_check_failure_threshold" {
  description = "Threshold de falhas para health check"
  type        = number
  default     = 3
}

variable "health_check_interval" {
  description = "Intervalo do health check (segundos)"
  type        = number
  default     = 30
}

variable "alarm_actions" {
  description = "Lista de ARNs para notificações de alarmes"
  type        = list(string)
  default     = []
}

variable "mx_records" {
  description = "Lista de MX records para email"
  type        = list(string)
  default     = []
}

variable "txt_records" {
  description = "Lista de TXT records"
  type        = list(string)
  default     = []
}

variable "cname_records" {
  description = "Map de CNAME records (subdomain => target)"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}
