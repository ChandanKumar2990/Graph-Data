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

