variable "default_vpc_id" {
  type = string
}

variable "region" {
  type = string
}

variable "name_prefix" {
  type = string
}

variable "env" {
  type = string
}

variable "product_name" {
  type = string
}

variable "global_default_tags" {
  type = map(any)
}

variable "default_kms_key_arn" {
  type = string
}

variable "account_id" {
  type = string
}

variable "ou" {
  type = string
}

variable "s3_access_log_bucket_name" {
  type = string
}

variable "network_type" {
  type = string
}

variable "dr_parameters" {
  type = map(any)
}

variable "s3_replication" {
  type = bool
}


