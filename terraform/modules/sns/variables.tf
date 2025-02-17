variable "name_prefix" {
  type    = string
  default = "sf"
}

variable "product_name" {
  type    = string
  default = "ecldata"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "env" {
  type    = string
  default = "sf"
}

variable "tags" {
  type = map(any)
}

variable "default_kms_key_arn" {
  type = string
}

variable "os_ingestion_events_sqs_feedback_role_arn" {
  type = string
}
