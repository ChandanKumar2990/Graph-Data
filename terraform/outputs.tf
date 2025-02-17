# VPC Outputs

output "neptune_db_security_group" {
  value = module.vpc.eclipse_neptune_security_group
}

output "base_sg_id" {
  value = module.vpc.base_sg_id
}

output "default_sg_id" {
  value = module.vpc.default_sg_id
}

# S3 bucket creation

output "eclipse_common_bucket_id" {
  value = module.s3.eclipse_common_bucket_id
}

output "eclipse_common_bucket_arn" {
  value = module.s3.eclipse_common_bucket_arn
}

output "eclipse_metadata_bucket_id" {
  value = module.s3.eclipse_common_bucket_id
}

output "eclipse_metadata_bucket_arn" {
  value = module.s3.eclipse_metadata_bucket_arn
}
