variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs das subnets privadas para o banco de dados"
  type        = list(string)
}

variable "database_security_group_id" {
  description = "ID do security group do banco de dados"
  type        = string
}

variable "engine" {
  description = "Engine do banco de dados (mysql, postgres, etc)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Versão do engine"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "Classe da instância RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Storage alocado em GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Máximo de storage para autoscaling em GB"
  type        = number
  default     = 100
}

variable "db_name" {
  description = "Nome do banco de dados"
  type        = string
}

variable "db_username" {
  description = "Username do banco de dados"
  type        = string
  default     = "admin"
}

variable "multi_az" {
  description = "Habilitar Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Período de retenção de backups em dias"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Janela de backup (UTC)"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Janela de manutenção"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Lista de logs para exportar para CloudWatch"
  type        = list(string)
  default     = ["postgresql", "upgrade"]
}

variable "skip_final_snapshot" {
  description = "Pular snapshot final ao deletar"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Habilitar proteção contra deleção"
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Habilitar upgrade automático de versão minor"
  type        = bool
  default     = true
}

variable "enable_performance_insights" {
  description = "Habilitar Performance Insights"
  type        = bool
  default     = false
}

variable "parameter_group_family" {
  description = "Família do parameter group"
  type        = string
  default     = "postgres15"
}

variable "db_parameters" {
  description = "Lista de parâmetros do banco de dados"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "create_read_replica" {
  description = "Criar read replica"
  type        = bool
  default     = false
}

variable "replica_instance_class" {
  description = "Classe da instância para read replica"
  type        = string
  default     = ""
}

variable "secret_recovery_days" {
  description = "Dias de recuperação para secrets deletados"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}
