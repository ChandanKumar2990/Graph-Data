locals {
  eclipse_common_bucket_name   = "${var.name_prefix}-${var.env}-${var.region}-${var.product_name}-common-bucket"
  eclipse_metadata_bucket_name = "${var.name_prefix}-${var.env}-${var.region}-${var.product_name}-metadata-bucket"
}

data "aws_s3_bucket" "eclipse_common_bucket" {
  count  = var.dr_parameters["deploy_s3"] ? 0 : 1
  bucket = local.eclipse_common_bucket_name
}

data "aws_s3_bucket" "eclipse_metadata_bucket" {
  count  = var.dr_parameters["deploy_s3"] ? 0 : 1
  bucket = local.eclipse_metadata_bucket_name
}
