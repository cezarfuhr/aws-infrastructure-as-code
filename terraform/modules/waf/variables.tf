variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "scope" {
  description = "Scope do WAF (REGIONAL para ALB, CLOUDFRONT para CloudFront)"
  type        = string
  default     = "REGIONAL"
  validation {
    condition     = contains(["REGIONAL", "CLOUDFRONT"], var.scope)
    error_message = "Scope must be either REGIONAL or CLOUDFRONT."
  }
}

variable "alb_arn" {
  description = "ARN do ALB para associar o WAF"
  type        = string
  default     = ""
}

variable "rate_limit" {
  description = "Número máximo de requisições por IP em 5 minutos"
  type        = number
  default     = 2000
}

variable "enable_ip_whitelist" {
  description = "Habilitar whitelist de IPs"
  type        = bool
  default     = false
}

variable "whitelisted_ips" {
  description = "Lista de IPs whitelistados (formato CIDR)"
  type        = list(string)
  default     = []
}

variable "enable_ip_blacklist" {
  description = "Habilitar blacklist de IPs"
  type        = bool
  default     = false
}

variable "blacklisted_ips" {
  description = "Lista de IPs bloqueados (formato CIDR)"
  type        = list(string)
  default     = []
}

variable "enable_ip_reputation" {
  description = "Habilitar Amazon IP Reputation List"
  type        = bool
  default     = true
}

variable "enable_bot_control" {
  description = "Habilitar Bot Control (custo adicional)"
  type        = bool
  default     = false
}

variable "enable_geo_blocking" {
  description = "Habilitar bloqueio geográfico"
  type        = bool
  default     = false
}

variable "blocked_countries" {
  description = "Lista de códigos de países a bloquear (ISO 3166-1 alpha-2)"
  type        = list(string)
  default     = []
}

variable "common_rule_set_exclusions" {
  description = "Lista de regras do Common Rule Set para excluir"
  type        = list(string)
  default     = []
}

variable "enable_logging" {
  description = "Habilitar logging do WAF"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Dias de retenção dos logs do WAF"
  type        = number
  default     = 30
}

variable "blocked_requests_threshold" {
  description = "Threshold para alarme de requisições bloqueadas"
  type        = number
  default     = 1000
}

variable "alarm_actions" {
  description = "Lista de ARNs para notificações de alarmes"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}
