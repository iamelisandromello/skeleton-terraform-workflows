#########################################
# variables.tf (root module)
#########################################

variable "aws_region" {
  description = "Região AWS onde os recursos serão provisionados"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name of the project derived from GitHub Repository name"
  type        = string

  validation {
    condition     = length(var.project_name) > 0
    error_message = "project_name não pode estar vazio."
  }
}

variable "environment" {
  description = "Nome do ambiente (ex: dev, prod, preview)"
  type        = string

  validation {
    condition     = length(var.environment) > 0
    error_message = "environment não pode estar vazio."
  }
}
  
# ================================
# Variáveis de ambiente da Lambda
# ================================

variable "global_env_vars" {
  description = "Mapa de ambientes com suas respectivas variáveis de ambiente para a Lambda"
  type        = map(string)
}

variable "environments" {
  description = "Ambiente (dev, prod, preview, etc.)"
  type = map(object({
    LOG_LEVEL = string
    DB_HOST   = string
    DB_NAME   = string
  }))
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3 onde o artefato da Lambda será armazenado"
  type        = string

  validation {
    condition     = length(var.s3_bucket_name) > 0
    error_message = "s3_bucket_name não pode estar vazio."
  }
}

# Variável para controlar a criação de uma NOVA fila SQS
variable "create_sqs_queue" {
  description = "Define se uma NOVA fila SQS deve ser criada (true/false)."
  type        = bool
  default     = false
}

# NOVO: Variável para controlar se usaremos uma fila SQS EXISTENTE como trigger
variable "use_existing_sqs_trigger" {
  description = "Define se uma fila SQS existente será usada como trigger para a Lambda."
  type        = bool
  default     = false
}

# MODIFICADO: Agora é o NOME da fila SQS existente
variable "existing_sqs_queue_name" {
  description = "O NOME da fila SQS existente a ser usada como trigger (requer use_existing_sqs_trigger=true)."
  type        = string
  default     = "" # Padrão vazio
}
