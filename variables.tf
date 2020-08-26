# ------------------------------------------------------------------
# Lambda Function variables, required
# ------------------------------------------------------------------

variable "lambda_function_name" {
  description = "The name of the lambda function the API Gateway is created for."
  type        = string
}

variable "lambda_invoke_arn" {
  description = "The arn (URI) of the lambda function the API Gateway is created for."
  type        = string
}

# ------------------------------------------------------------------
# API Gateway variables, optional
# ------------------------------------------------------------------

variable "apigw_name" {
  description = "Name of the API Gateway to be created."
  type        = string
  default     = "apigateway"
}

variable "apigw_description" {
  description = "Description of the API Gateway to be created."
  type        = string
  default     = "created by module alparius/apigateway-with-cors"
}

variable "stage_name" {
  description = "The name of the stage. Part of the API resource's path."
  type        = string
  default     = "default"
}

variable "path_part" {
  description = "The last path segment of the API resource. The default matches everything."
  type        = string
  default     = "{proxy+}"
}

variable "http_method" {
  description = "The HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)."
  type        = string
  default     = "GET"
}
