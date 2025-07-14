#########################################
# outputs.tf (lambda module)
#########################################

output "lambda_function_name" {
  value = aws_lambda_function.lambda.function_name
}

output "lambda_arn" {
  value = aws_lambda_function.lambda.arn
}

output "lambda_layers" {
  description = "Lista de Layers anexadas à Lambda"
  value       = aws_lambda_function.lambda.layers
}