output "eclipse_common_bucket_id" {
  value = var.dr_parameters["deploy_s3"] ? aws_s3_bucket.eclipse_common_bucket[0].id : data.aws_s3_bucket.eclipse_common_bucket[0].id
}

output "eclipse_common_bucket_arn" {
  value = var.dr_parameters["deploy_s3"] ? aws_s3_bucket.eclipse_common_bucket[0].arn : data.aws_s3_bucket.eclipse_common_bucket[0].arn
}

output "eclipse_metadata_bucket_id" {
  value = var.dr_parameters["deploy_s3"] ? aws_s3_bucket.eclipse_metadata_bucket[0].id : data.aws_s3_bucket.eclipse_metadata_bucket[0].id
}

output "eclipse_metadata_bucket_arn" {
  value = var.dr_parameters["deploy_s3"] ? aws_s3_bucket.eclipse_metadata_bucket[0].arn : data.aws_s3_bucket.eclipse_metadata_bucket[0].arn
}
