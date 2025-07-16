#########################################
# main.tf (lambda module)
#########################################

resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_name
  role          = var.role_arn
  handler       = var.handler
  runtime       = var.runtime
  s3_bucket     = var.s3_bucket
  s3_key        = var.s3_key
  timeout       = var.timeout     
  memory_size   = var.memory_size 

  # Configuração da VPC
  dynamic "vpc_config" {
    # Este bloco `vpc_config` só será criado se um vpc_id for fornecido E se houver subnets e security groups.
    # Isso permite que a Lambda seja deployada fora da VPC se as variáveis estiverem vazias.
    for_each = var.vpc_id != "" && length(var.subnet_ids) > 0 && length(var.security_group_ids) > 0 ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids
    }
  }

  environment {
    variables = var.environment_variables
  }
  
  # Preconditions para garantir a lógica de SQS condicional
  lifecycle {
    precondition {
      # Validação de mutualidade exclusiva: create_sqs_queue e use_existing_sqs_trigger não podem ser true ao mesmo tempo.
      condition     = !(var.create_sqs_queue && var.use_existing_sqs_trigger)
      error_message = "As variáveis 'create_sqs_queue' e 'use_existing_sqs_trigger' não podem ser true ao mesmo tempo. Escolha apenas uma opção para SQS."
    }
    precondition {
      # Validação: existing_sqs_queue_arn deve ser fornecido se use_existing_sqs_trigger for true.
      condition     = var.use_existing_sqs_trigger ? (var.existing_sqs_queue_arn != "") : true
      error_message = "existing_sqs_queue_arn deve ser fornecido e não vazio se use_existing_sqs_trigger for true."
    }
    # --- Precondition para VPC ---
    precondition {
      # Se vpc_id for fornecido, subnet_ids e security_group_ids não podem ser vazios.
      condition     = var.vpc_id == "" || (length(var.subnet_ids) > 0 && length(var.security_group_ids) > 0)
      error_message = "Se 'vpc_id' for fornecido, 'subnet_ids' e 'security_group_ids' devem ser informados e não podem estar vazios."
    }
  }

  tags = { # É bom ter tags no recurso Lambda
    Project     = var.project_name
    Environment = var.environment
  }
}