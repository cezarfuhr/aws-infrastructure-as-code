variable "project_name" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente (dev, staging, prod)"
  type        = string
}

variable "enable_versioning" {
  description = "Habilitar versionamento do S3"
  type        = bool
  default     = true
}

variable "enable_lifecycle_rules" {
  description = "Habilitar regras de lifecycle"
  type        = bool
  default     = true
}

variable "default_root_object" {
  description = "Objeto root padrão do CloudFront"
  type        = string
  default     = "index.html"
}

variable "price_class" {
  description = "Price class do CloudFront"
  type        = string
  default     = "PriceClass_100"
}

variable "domain_aliases" {
  description = "Lista de aliases de domínio"
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ARN do certificado ACM para HTTPS"
  type        = string
  default     = ""
}

variable "geo_restriction_type" {
  description = "Tipo de restrição geográfica (none, whitelist, blacklist)"
  type        = string
  default     = "none"
}

variable "geo_restriction_locations" {
  description = "Lista de códigos de países para restrição geográfica"
  type        = list(string)
  default     = []
}

variable "logs_retention_days" {
  description = "Dias de retenção para logs no S3"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags para recursos"
  type        = map(string)
  default     = {}
}
