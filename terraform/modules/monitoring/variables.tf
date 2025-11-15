variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "aws_region" {
  description = "Região AWS"
  type        = string
}

variable "alarm_email_endpoints" {
  description = "Lista de emails para receber notificações de alarmes"
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "Dias de retenção para logs do CloudWatch"
  type        = number
  default     = 30
}

variable "error_threshold" {
  description = "Threshold para alarme de erros de aplicação"
  type        = number
  default     = 10
}

variable "error_5xx_threshold" {
  description = "Threshold para alarme de erros 5xx do ALB"
  type        = number
  default     = 20
}

variable "response_time_threshold" {
  description = "Threshold para alarme de tempo de resposta (segundos)"
  type        = number
  default     = 2
}

variable "slow_request_threshold" {
  description = "Threshold para considerar uma requisição lenta (ms)"
  type        = number
  default     = 1000
}

variable "target_group_arn" {
  description = "ARN do target group do ALB"
  type        = string
  default     = ""
}

variable "alb_arn" {
  description = "ARN do Application Load Balancer"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}
