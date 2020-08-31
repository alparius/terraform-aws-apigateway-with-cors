[![GitHub][github-image]][github-link]

  [github-image]: https://img.shields.io/github/release/alparius/terraform-aws-apigateway-with-cors.svg
  [github-link]: https://github.com/alparius/terraform-aws-apigateway-with-cors/releases

# Terraform AWS API Gateway with CORS Enabled

An opinionated Terraform module for the AWS provider, creating a CORS-enabled API Gateway for a Lambda function.

It creates the required resources for the Lambda function to be called through the API Gateway. Also defines an OPTIONS method, to bypass the Cross-Origin Resource Sharing policies of your browser, thus allowing your Lambda function to be called by other resources. Additionally, creates the permission for this new API Gateway to be able to invoke your Lambda function.


## Usage

### Using the module

``` hcl
module "apigateway_with_cors" {
  source  = "alparius/apigateway-with-cors/aws"
  version = "0.3.0"

  lambda_function_name = aws_lambda_function.<your_lambda_function>.function_name
  lambda_invoke_arn    = aws_lambda_function.<your_lambda_function>.invoke_arn 
}
```

### Together with your Lambda function
``` hcl
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_name"
  role          = aws_iam_role.lambda_exec.arn

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = "my_lambda.zip"

  handler = "index.handler"
  runtime = "nodejs10.x"
}

module "apigateway_with_cors" {
  source  = "alparius/apigateway-with-cors/aws"
  version = "0.3.0"

  lambda_function_name = aws_lambda_function.my_lambda.function_name
  lambda_invoke_arn    = aws_lambda_function.my_lambda.invoke_arn
  
  request_parameters = { "method.request.querystring.number" = true }
  request_templates  = {
    "application/json" = <<EOF
    { "number" : "$input.params('number')" }
    EOF
  }
}
```


## Inputs

The following input variables can be provided:

### Required

#### `lambda_function_name`
- **Description**: The name of the lambda function the API Gateway is created for.
- **Default**: `none`

#### `lambda_invoke_arn`
- **Description**: The arn (URI) of the lambda function the API Gateway is created for.
- **Default**: `none`

### Optional

#### `http_method`
- **Description**: The HTTP method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY).
- **Default**: `GET`

#### `path_part`
- **Description**: The last path segment of the API resource. The default '{proxy+}' matches everything.
- **Default**: `{proxy+}`

#### `request_parameters`
- **Description**: Parameters of the method call. Query strings, for example.
- **Default**: `{}`

#### `request_templates`
- **Description**: Mapping of the request parameters of the method call.
- **Default**: `{}`

#### `stage_name`
- **Description**: The name of the stage. Part of the API resource's path.
- **Default**: `default`


## Outputs

#### `lambda_url`
- **Description**: The public URL pointing to your lambda function. If 'path_part' is left as default, it will match everything.
