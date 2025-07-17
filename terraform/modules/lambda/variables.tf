#########################################
# variables.tf (lambda module)
#########################################

variable "lambda_name"      { type = string }
variable "role_arn"         { type = string }
variable "s3_bucket"        { type = string }
variable "s3_key"           { type = string }

variable "environment_variables" {
  type = map(string)
}

variable "handler" {
  type = string
}

variable "runtime" {
  type = string
}

variable "project_name" {
  description = "Nome do projeto."
  type        = string
}

variable "environment" {
  description = "Ambiente de implantação."
  type        = string
}

# Variáveis passadas do módulo raiz para a Lambda para preconditions
variable "create_sqs_queue" {
  description = "Define se uma nova fila SQS será criada (para uso em preconditions)."
  type        = bool
  default     = false
}

variable "use_existing_sqs_trigger" {
  description = "Define se uma fila SQS existente será usada como trigger (para uso em preconditions)."
  type        = bool
  default     = false
}

variable "existing_sqs_queue_arn" {
  description = "ARN da fila SQS existente se usada como trigger (para uso em preconditions)."
  type        = string
  default     = ""
}

# Variável para o nome da fila SQS existente (passada do módulo raiz)
variable "existing_sqs_queue_name" {
  description = "Nome da fila SQS existente se usada como trigger (para uso em preconditions e logging)."
  type        = string
  default     = ""
}

# --- VARIÁVEIS PARA CONFIGURAÇÃO DE REDE E PERFORMANCE ---
variable "vpc_id" {
  description = "O ID da VPC para a função Lambda. Opcional."
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "Uma lista de IDs de subnets para a função Lambda. Opcional."
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "Uma lista de IDs de Security Groups para a função Lambda. Opcional."
  type        = list(string)
  default     = []
}

variable "timeout" {
  description = "O tempo limite de execução da Lambda em segundos."
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "A quantidade de memória em MB que sua função Lambda terá acesso."
  type        = number
  default     = 128
}