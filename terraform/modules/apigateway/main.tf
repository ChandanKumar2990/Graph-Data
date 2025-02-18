# Api Gateway
resource "aws_api_gateway_rest_api" "eclipse_data_restapi" {
  count       = var.create_api_resources ? 1 : 0
  name        = "${var.name_prefix}-${var.env}-${var.region}-${var.product_name}-restapi"
  description = "Eclipse Data Graph API Gateway for rest APIs"
  endpoint_configuration {
    types = ["PRIVATE"]
  }
  tags = merge(tomap({ "access-env" = var.env }), var.tags)
}

# API Gateway Resource based policy
resource "aws_api_gateway_authorizer" "eclipse_rest_api_authorizer" {
  count       = var.create_api_resources ? 1 : 0
  policy      = data.aws_iam_policy_document.apigateway_resource_based_policy[0].json
  rest_api_id = aws_api_gateway_rest_api.eclipse_data_restapi[0].id
  depends_on  = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

# Api Gateway Authorizer
resource "aws_api_gateway_authorizer" "eclipse_rest_api_authorizer" {
  count                            = var.create_api_resources ? 1 : 0
  name                             = "${var.name_prefix}-${var.env}-${var.region}-${var.product_name}-ag-authorizer"
  rest_api_id                      = aws_api_gateway_rest_api.eclipse_data_restapi[0].id
  authorizer_uri                   = var.eclipse_ag_azure_lambda_invoke_arn
  authorizer_credentials           = var.authorizer_credentials
  authorizer_result_ttl_in_seconds = 0
  depends_on                       = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

# Api Gateway Resource
resource "aws_api_gateway_resource" "api_gateway_env_path" {
  count       = var.create_api_resources ? 1 : 0
  parent_id   = var.ecldata_restapi_details["root_resource_id"]
  path_part   = var.env
  rest_api_id = var.eclipse_restapi_details["restapi_id"]
  depends_on  = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

resource "aws_api_gateway_resource" "api_gateway_proxy_path" {
  count       = var.create_api_resources ? 1 : 0
  parent_id   = var.ecldata_restapi_details["root_resource_id"]
  path_part   = "{proxy+}"
  rest_api_id = var.eclipse_restapi_details["restapi_id"]
  depends_on  = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

resource "aws_api_gateway_method" "proxy_any_method" {
  count         = var.create_api_resources ? 1 : 0
  rest_api_id   = var.ecldata_restapi_details["restapi_id"]
  resource_id   = aws_api_gateway_resource.api_gateway_proxy_path[0].id
  http_method   = "GET"
  authorization = "NONE"
  #   authorizer_id = var.ecldata_restapi_details["authorizer_id"]
  depends_on = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

resource "aws_api_gateway_integration" "proxy_get_method_integration" {
  count = var.create_api_resources ? 1 : 0
  depends_on = [
    aws_api_gateway_resource.api_gateway_proxy_path,
    aws_api_gateway_rest_api.eclipse_data_restapi
  ]
  rest_api_id             = var.ecldata_restapi_details["restapi_id"]
  resource_id             = aws_api_gateway_resource.api_gateway_proxy_path[0].id
  http_method             = aws_api_gateway_method.proxy_any_method[0].http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.eclipse_data_lambda_api_function.invoke_arn
}

# locals for Parent_id
locals {
  parent_id = var.env == "prod" ? var.ecldata_restapi_details["root_resource_id"] : aws_api_gateway_resource.api_gateway_env_path[0].vpc_id
}

# Child resource creation
resource "aws_api_gateway_resource" "admin_controls_api_resource" {
  parent_id   = local.parent_id
  path_part   = "admincontrols"
  rest_api_id = var.ecldata_restapi_details["restapi_id"]
  depends_on  = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

# API Gateway method
resource "aws_api_gateway_method" "admin_controls_method" {
  rest_api_id   = var.ecldata_restapi_details["restapi_id"]
  resource_id   = aws_aoi_gateway_resource.admin_controls_api_resource.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = var.eclipse_restapi_details["authorizer_id"]
  depends_on    = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

# API Gateway Method integration for admin controls
resource "aws_api_gateway_integration" "admin_controls_method_integration" {
  depends_on = [
    aws_api_gateway_resource.admin_controls_api_resource,
    aws_api_gateway_rest_api.eclipse_data_restapi
  ]
  rest_api_id             = var.ecldata_restapi_details["restapi_id"]
  resource_id             = aws_api_gateway_resource.admin_controls_api_resource.id
  http_method             = aws_api_gateway_method.admin_controls_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.eclipse_data_lambda_api_function.arn}:${stageVariables.dal_api_lamnbda}/invocations"
}

# Child resource creation
resource "aws_api_gateway_resource" "agreements_api_resource" {
  parent_id   = local.parent_id
  path_part   = "agreements"
  rest_api_id = var.ecldata_restapi_details["restapi_id"]
  depends_on  = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

# API Gateway method
resource "aws_api_gateway_method" "agreements_api_method" {
  rest_api_id   = var.ecldata_restapi_details["restapi_id"]
  resource_id   = aws_aoi_gateway_resource.agreements_api_resource.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = var.eclipse_restapi_details["authorizer_id"]
  depends_on    = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

# API Gateway Method integration for agreements
resource "aws_api_gateway_integration" "agreements_api_method_integration" {
  depends_on = [
    aws_api_gateway_resource.agreements_api_resource,
    aws_api_gateway_rest_api.eclipse_data_restapi
  ]
  rest_api_id             = var.ecldata_restapi_details["restapi_id"]
  resource_id             = aws_api_gateway_resource.agreements_api_resource.id
  http_method             = aws_api_gateway_method.agreements_api_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.eclipse_data_lambda_api_function.arn}:${stageVariables.dal_api_lamnbda}/invocations"
}

resource "aws_api_gateway_resource" "agreements_api_proxy_resource" {
  rest_api_id = var.ecldata_restapi_details["restapi_id"]
  parent_id   = aws_aoi_gateway_resource.agreement_api_resource.id
  path_part   = "{proxy+}"
  depends_on  = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

resource "aws_api_gateway_integration" "agreements_api_proxy_resource_method_integration" {
  rest_api_id             = var.ecldata_restapi_details["restapi_id"]
  resource_id             = aws_api_gateway_resource.agreements_api_proxy_resource.id
  http_method             = aws_api_gateway_method.agreements_api_proxy_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.eclipse_data_lambda_api_function.arn}:${stageVariables.dal_api_lamnbda}/invocations"
  depends_on              = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

resource "aws_api_gateway_method" "agreements_api_proxy_method" {
  rest_api_id   = var.ecldata_restapi_details["restapi_id"]
  resource_id   = aws_api_gateway_resource.agreements_api_proxy_resource.id
  http_method   = "ANY"
  authorization = "CUSTOM"
  authorizer_id = var.ecldata_restapi_details["authorizer_id"]
  depends_on    = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

resource "aws_lambda_permission" "agreement_api_proxy_lambda_permission" {
  depends_on = [
    aws_api_gateway_resource.agreements_api_proxy_resource
  ]
  for_each      = var.stage_details
  statement_id  = "AllowExecutionFromAPIGatewayAgreementProxy"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eclipse_data_lamnbda_api_function.function_name
  principal     = "apigateway.amazon.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${var.account_id}:${var.ecldata_restapi_details["restapi_id"]}/*/*:${aws_api_gateway_resource.agreements_api_resource.path}/*"
  qualifier     = aws_lambda_alias.eclipse_data_lambda_api_function_alias[each.key].name
}

#Cors for API Gateway

module "agreements_cors" {
  source          = "../cors"
  api_id          = var.ecldata_restapi_details["restapi_id"]
  api_resource_id = aws_api_gateway_resource.agreements_api_resource.id
  depends_on      = [aws_api_gateway_rest_api.eclipse_data_restapi]
}

module "agreements_proxy_cors" {
  source          = "../cors"
  api_id          = var.ecldata_restapi_details["restapi_id"]
  api_resource_id = aws_api_gateway_resource.agreements_api_proxy_resource.id
  depends_on      = [aws_api_gateway_resource.agreements_api_proxy_resource]
}

#############################################
# Lambda Function Creation
#############################################

#Archiving the lambda function
data "archive_file" "eclipse_data_lambda_api_archive" {
  type        = "zip"
  source_dir  = "${path.cwd}/src/lambda_function/dal_lambda_function"
  output_path = "${path.module}/dal_api_lambda.zip"
}

#Uploading the lambda function to S3 bucket
resource "aws_s3_object" "eclipse_data_lambda_api_s3_object" {
  bucket = var.deployment_bucket_id
  key    = "deployment_package/ecldata/dal_api_lambda.zip"
  source = data.archive_file.eclipse_data_lambda_api_archive.output_path
  etag   = data.archive_file.eclipse_data_lambda_api_archive.output_md5
}

# Creation of Lambda function for Eclipse Data API
resource "aws_lambda_function" "eclipse_data_lambda_api_function" {
  function_name    = "${var.name_prefix}-${var.env}-${var.region}-${var.product_name}-dal-api-lambda-function"
  description      = "Lambda function for dal api"
  s3_bucket        = var.deployment_bucket_id
  s3_key           = aws_s3_object.eclipse_data_lambda_api_s3_object.s3_key
  runtime          = var.python_runtime_version
  handler          = "main.lambda_handler"
  source_code_hash = data.archive_file.eclipse_data_lambda_api_archive.output_base64sha256
  role             = var.dal_api_lambda_role_arn
  publish          = var.publish_new_lambda_version["dal_api_lambda"]
  timeout          = 600
  memory_size      = 2048
  vpc_config {
    subnet_ids = [
      var.subnet_ids["private1"],
      var.subnet_ids["private2"]
    ]
    security_group_ids = [
      var.security_groups["default_security_group"],
      var.security_groups["neptune_db_security_group"]
    ]
  }
  tags = merge(tomap({ "access-env" = var.env }), var.tags)
  layers = [
    var.layer_arns["gremlin_layer_arn"],
    var.layer_arns["fastapi_layer_arn"],
    var.layer_arns["eclipse_util_layer_arn"],
    var.layer_arns["data_wrangler_layer_arn"],
    var.layer_arns["vault_layer_arn"]
  ]
  environment {
    variables = {
      LOG_LEVEL                    = var.log_level
      DR_WRITER_ENDPOINT           = var.db_endpoints["writer_endpoint"]
      DR_READER_ENDPOINT           = var.db_endpoints["reader_endpoint"]
      ENVIRONMENT                  = var.env
      STAGE                        = var.stage_name
      EVENT_NOTIFICATION_TOPIC_ARN = var.event_notification_topic_arn
      AGREEMENT_INDEX              = var.agreement_index
    }
  }
}

resource "aws_cloudwatch_log_group" "eclipse_data_lambda_api_cw_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.eclipse_data_lambda_api_function.function_name}"
  retention_in_days = 120
  tags              = merge(tomap({ "access-env" = var.env }), var.tags)
}
