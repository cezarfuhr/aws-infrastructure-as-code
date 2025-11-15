variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
  default     = ""
}

variable "ec2_iam_role_name" {
  description = "Nome do IAM role das instâncias EC2"
  type        = string
  default     = ""
}

variable "enable_session_logging" {
  description = "Habilitar logging de sessões no S3"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_logging" {
  description = "Habilitar logging de sessões no CloudWatch"
  type        = bool
  default     = true
}

variable "enable_kms_encryption" {
  description = "Habilitar encriptação KMS das sessões"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Dias de retenção dos logs no S3"
  type        = number
  default     = 90
}

variable "cloudwatch_log_retention_days" {
  description = "Dias de retenção dos logs no CloudWatch"
  type        = number
  default     = 30
}

variable "run_as_enabled" {
  description = "Habilitar execução como usuário específico"
  type        = bool
  default     = false
}

variable "run_as_default_user" {
  description = "Usuário padrão para execução"
  type        = string
  default     = ""
}

variable "idle_session_timeout" {
  description = "Timeout de sessão idle em minutos"
  type        = string
  default     = "20"
}

variable "max_session_duration" {
  description = "Duração máxima da sessão em minutos"
  type        = string
  default     = "60"
}

variable "create_bastion_security_group" {
  description = "Criar security group dedicado para bastion"
  type        = bool
  default     = false
}

variable "enable_activity_alarms" {
  description = "Habilitar alarmes de atividade"
  type        = bool
  default     = true
}

variable "session_activity_threshold" {
  description = "Threshold para alarme de atividade de sessão"
  type        = number
  default     = 10
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
