# Data Resource for versioning api gateway resource based policy

data "aws_iam_policy_document" "apigateway_resource_based_policy" {
  count   = var.create_api_resources ? 1 : 0
  version = "2012-10-17"
  statement {
    principals {
      identifiers = ["*"]
      type        = "*"
    }
    actions = [
      "execute-api:Invoke",
    ]
    effect    = "Allow"
    sid       = "RegistrationAPIGatewayResourceBasedPolicyAllowed"
    resources = ["arn:aws:execute-api:${var.region}:${var.account_id}:${aws_api_gateway_rest_api.eclipse_data_restapi[0].id}/*"]
    condition {
      test     = "StringEquals"
      values   = [var.vpc_endpoint_id]
      variable = "aws:SourceVpce"
    }
  }
}
