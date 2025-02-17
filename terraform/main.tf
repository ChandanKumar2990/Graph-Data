data "aws_caller_identity" "current" {}

# VPC Module

module "vpc" {
  source       = "./modules/vpc"
  name_prefix  = var.name_prefix
  product_name = var.product_name
  region       = var.region
  env          = var.env
  cidr_blocks = {
    default_subnet_cidrs  = module.vpc.default_subnet_cidrs
    selected_subnet_cidrs = module.vpc.selected_subnet_cidrs
  }
  tags          = var.global_default_tags
  vpc_id        = var.default_vpc_id
  network_type  = var.network_type
  dr_parameters = var.dr_parameters
}

# S3 Bucket

module "s3" {
  source                    = "./modules/s3"
  account_id                = var.account_id
  env                       = var.env
  kms_master_key_arn        = var.default_kms_key_arn
  name_prefix               = var.name_prefix
  ou                        = var.ou
  product_name              = var.product_name
  region                    = var.region
  s3_access_log_bucket_name = var.s3_access_log_bucket_name
  tags                      = var.global_default_tags
  s3_replication            = var.s3_replication
  dr_parameters             = var.dr_parameters
}

# SNS Module

module "sns" {
  source                                    = "./modules/sns"
  name_prefix                               = var.name_prefix
  product_name                              = var.product_name
  region                                    = var.region
  env                                       = var.env
  default_kms_key_arn                       = var.default_kms_key_arn
  os_ingestion_events_sqs_feedback_role_arn = module.iam.os_ingestion_events_sqs_feedback_role_arn
  tags                                      = var.global_default_tags
}
