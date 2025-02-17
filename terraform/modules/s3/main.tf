#############################################################################################
# Common S3 bucket
#############################################################################################
resource "aws_s3_bucket" "eclipse_common_bucket" {
  count  = var.dr_parameters["deploy_s3"] ? 1 : 0
  bucket = "${var.name_prefix}-${var.env}-${var.region}-${var.product_name}-common-bucket"
  tags   = merge(tomap({ "access-env" = var.env }), var.tags)
}

# Versioning
resource "aws_s3_bucket_versioning" "versioning_eclipse_common_bucket" {
  count  = var.dr_parameters["deploy_s3"] ? 1 : 0
  bucket = aws_s3_bucket.eclipse_common_bucket[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

# Life cycle configuration
resource "aws_s3_bucket_lifecycle_configuration" "eclipse_common_bucket_lifecycle_config" {
  count  = var.dr_parameters["deploy_s3"] ? 1 : 0
  bucket = aws_s3_bucket.eclipse_common_bucket[0].id
  rule {
    id = "expire_object"
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
    noncurrent_version_expiration {
      noncurrent_days = 60
    }
    status = "Enabled"
  }
}

# SSE encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "eclipse_common_bucket_access_logging" {
  count  = var.dr_parameters["deploy_s3"] ? 1 : 0
  bucket = aws_s3_bucket.eclipse_common_bucket[0].bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.kms_master_key_arn
    }
    bucket_key_enabled = true
  }
}

# Access logging
resource "aws_s3_bucket_logging" "eclipse_common_bucket_access_logging" {
  count         = var.dr_parameters["deploy_s3"] ? 1 : 0
  bucket        = aws_s3_bucket.eclipse_common_bucket[0].id
  target_bucket = "${var.s3_access_log_bucket_name}-${var.region}"
  target_prefix = "${var.ou}/${var.account_id}/${aws_s3_bucket.eclipse_common_bucket[0].id}/"
}

resource "aws_s3_bucket_replication_configuration" "s3_bucket_replication" {
  count  = var.dr_parameters["deploy_s3"] ? 1 : 0
  bucket = aws_s3_bucket.eclipse_common_bucket[0].id
  role   = "arn:aws:iam::${var.account_id}:role/sf-s3-replication-role"
  rule {
    id       = "bucket_crr"
    status   = "Enabled"
    priority = 1
    filter {
      prefix = ""
    }

    source_selection_criteria {
      replica_modifications {
        status = "Enabled"
      }
      sse_kms_encrypted_objects {
        status = "Enabled"
      }
    }
    destination {
      bucket  = "arn:aws:s3:::${var.name_prefix}-${var.env}-${var.dr_parameters["dr_retion"]}-${var.product_name}-common-bucket"
      account = var.account_id
      access_control_translation {
        owner = "Destination"
      }
      encryption_configuration {
        replica_kms_key_id = var.dr_parameters["dr_default_kms_key_arn"]
      }
    }
    delete_marker_replication {
      status = "Enabled"
    }
  }
}
