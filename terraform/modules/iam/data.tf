# Lambda Assumed Role Policy Document

data "aws_iam_policy_document" "ecldata_lambda_assumed_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    sid     = "LambdaAssumePolicy"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

# Lambda VPC Execution Policy Document
data "aws_iam_policy_document" "ecldata_vpc_lambda_basic_execution_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "ec2:CreateNeptuneInterface",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses"
    ]
    effect    = "Allow"
    sid       = "lambdaVPCExecutionAllow"
    resources = ["*"]
  }
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect = "Allow"
    sid    = "AllowCreateLogs"
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:*${var.product_name}",
      "arn:aws:logs:${var.dr_parameters["dr_region"]}:${var.account_id}:*${var.product_name}-*"
    ]
  }
}

# Allow KMS Decrypt Policy Document

data "aws_iam_policy_document" "ecldata_kms_decrypt_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "kms:GenerateDataKey",
      "kms:Decrypt"
    ]
    effect = "Allow"
    sid    = "DecryptKMSAllowPolicy"
    resources = [
      var.default_kms_key_arn,
      var.dr_parameters["dr_default_kms_key_arn"]
    ]
  }
}

#Neptune Read/write policy
data "aws_iam_policy_document" "neptune_read_write_policy" {
  version = "2012-10-17"
  statement {
    actions = [
      "neptune-db:ReadDataViaQuery",
      "neptune-db:WriteDataViaQuery",
      "neptune-db:DeleteDataViaQuery",
      "neptune-db:GetStreamRecords"
    ]
    effect = "Allow"
    sid    = "NeptuneReadWrite"
    resources = [
      "arn:aws:neptune-db:${var.region}:${var.account_id}:${var.neptune_cluster_resource_id}/*",
      "arn:aws:neptune-db:${var.dr_parameters["dr_region"]}:${var.account_id}:*"
    ]
  }
}
