output "lambda_url" {
  description = "The public URL pointing to your lambda function. Don't forget to append the 'path_part'."
  value       = aws_api_gateway_deployment.deployment.invoke_url
}
