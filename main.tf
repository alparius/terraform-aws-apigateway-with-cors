# ------------------------------------------------------------------
# the API Gateway and the main method
# ------------------------------------------------------------------

### the gateway itself
resource "aws_api_gateway_rest_api" "apigateway" {
  name        = var.apigw_name
  description = var.apigw_description
}


### permission to invoke lambdas
resource "aws_lambda_permission" "apigw_access_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.apigateway.execution_arn}/*/*"
}


### api gateway resource
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  parent_id   = aws_api_gateway_rest_api.apigateway.root_resource_id
  path_part   = var.path_part
}


### connecting the api gateway with the internet
resource "aws_api_gateway_method" "main_method" {
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = var.http_method
  authorization = "NONE"

  # request_parameters = var.request_parameters
}


### connecting the api gateway with the lambda
resource "aws_api_gateway_integration" "method_integration" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_method.main_method.resource_id
  http_method = aws_api_gateway_method.main_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn

  # request_templates = var.request_templates

  depends_on = [aws_api_gateway_method.main_method]
}


# ------------------------------------------------------------------
# enabling CORS by adding an OPTIONS method
# ------------------------------------------------------------------

resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.apigateway.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}


resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }

  depends_on = [aws_api_gateway_method.options_method]
}


resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{ \"statusCode\": 200 }"
  }

  depends_on = [aws_api_gateway_method.options_method]
}


resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  depends_on = [
    aws_api_gateway_method_response.options_response,
    aws_api_gateway_integration.options_integration
  ]
}


# ------------------------------------------------------------------
# at last, the deployment
# ------------------------------------------------------------------

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.apigateway.id
  stage_name  = var.stage_name

  depends_on = [
    aws_api_gateway_integration.method_integration,
    aws_api_gateway_integration.options_integration
  ]
}
