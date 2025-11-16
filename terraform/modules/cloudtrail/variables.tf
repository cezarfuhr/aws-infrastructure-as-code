variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "is_multi_region_trail" {
  description = "Criar trail multi-region"
  type        = bool
  default     = true
}

variable "enable_kms_encryption" {
  description = "Habilitar encriptação KMS"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_logs" {
  description = "Enviar logs para CloudWatch"
  type        = bool
  default     = true
}

variable "cloudwatch_log_retention_days" {
  description = "Dias de retenção dos logs no CloudWatch"
  type        = number
  default     = 90
}

variable "enable_data_events" {
  description = "Habilitar logging de data events (S3, Lambda)"
  type        = bool
  default     = false
}

variable "enable_insights" {
  description = "Habilitar CloudTrail Insights"
  type        = bool
  default     = false
}

variable "enable_advanced_event_selectors" {
  description = "Usar advanced event selectors"
  type        = bool
  default     = false
}

variable "advanced_event_selectors" {
  description = "Lista de advanced event selectors"
  type = list(object({
    name = string
    field_selectors = list(object({
      field       = string
      equals      = optional(list(string))
      not_equals  = optional(list(string))
      starts_with = optional(list(string))
    }))
  }))
  default = []
}

variable "enable_sns_notifications" {
  description = "Habilitar notificações SNS"
  type        = bool
  default     = false
}

variable "enable_security_alarms" {
  description = "Criar alarmes de segurança"
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "Lista de ARNs para notificações de alarmes"
  type        = list(string)
  default     = []
}

variable "transition_to_ia_days" {
  description = "Dias até transição para IA"
  type        = number
  default     = 90
}

variable "transition_to_glacier_days" {
  description = "Dias até transição para Glacier"
  type        = number
  default     = 180
}

variable "expiration_days" {
  description = "Dias até expiração dos logs"
  type        = number
  default     = 365
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}
