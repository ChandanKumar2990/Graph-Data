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

variable "vpc_id" {
  type = string
}

variable "cidr_blocks" {
  type = map(any)
}

variable "network_type" {
  type = map(any)
}

variable "dr_parameters" {
  type = map(any)
}
