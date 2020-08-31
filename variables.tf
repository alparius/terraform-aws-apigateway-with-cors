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

variable "http_method" {
  description = "The HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)."
  type        = string
  default     = "GET"
}

variable "path_part" {
  description = "The last path segment of the API resource. The default '{proxy+}' matches everything."
  type        = string
  default     = "{proxy+}"
}

variable "request_parameters" {
  description = "Parameters of the method call. Query strings, for example."
  type        = map
  default     = {}
}

variable "request_templates" {
  description = "Mapping of the request parameters of the method call."
  type        = map
  default     = {}
}

variable "stage_name" {
  description = "The name of the stage. Part of the API resource's path."
  type        = string
  default     = "default"
}

