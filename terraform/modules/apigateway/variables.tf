variable "name_prefix" {
  type = string
}

variable "region" {
  type = string
}

variable "product_name" {
  type = string
}

variable "env" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "account_id" {
  type = string
}

variable "vpc_endpoint_id" {
  type = string
}

variable "subnet_ids" {
  type = map(any)
}

variable "security_groups" {
  type = map(any)
}

variable "log_level" {
  type = string
}

variable "layer_arns" {
  type = string
}

variable "dal_api_lambda_role_arn" {
  type = map(any)
}

variable "db_endpoints" {
  type = map(any)
}


