variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC"
  type        = string
}

variable "ssh_allowed_cidr_blocks" {
  description = "Lista de CIDR blocks permitidos para SSH"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}
