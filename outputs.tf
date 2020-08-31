output "lambda_url" {
  description = "The public URL pointing to your lambda function. If 'path_part' is left as default, it will match everything"
  value = "${aws_api_gateway_deployment.deployment.invoke_url}${aws_api_gateway_resource.proxy.path}"
}