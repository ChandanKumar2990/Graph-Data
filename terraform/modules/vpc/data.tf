#Fetching all private subnets based on tags

data "aws_subnets" "private_subnets" {
  for_each = var.network_type["tiers"]
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  filter {
    name   = "tag:networks"
    values = ["private"]
  }
  tags = {
    network = "private",
    tier    = each.value,
  }
}

# Pull subnet cidrs from selected_subnets resource
data "aws_subnet" "selected_subnet" {
  for_each = toset(data.aws_subnets.private_subnets[var.network_type["selected_tier"]["network_type"]]).ids
  id       = each.value
}

# Pull subnet cidrs from default_subnets resource
data "aws_subnet" "default_subnet" {
  for_each = toset(data.aws_subnets.private_subnets[var.network_type["selected_tier"]["network_type"]]).ids
  id       = each.value
}

# Pull the same base-sg security groups
data "aws_security_groups" "base" {
  filter {
    name   = "group-name"
    values = ["base_sg"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

# Pull the default-sg security groups
data "aws_security_groups" "default" {
  filter {
    name   = "group-name"
    values = ["default"]
  }

  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_vpc_endpoint" "api_interface_endpoint" {
  vpc_id       = var.vpc_id
  service_name = var.dr_parameters["vpc_endpoint_service_name"]
}

locals {
  ag_vpce_eni_ids = tolist(data.aws_vpc_endpoint.api_interface_endpoint.network_interface_ids)
}

data "aws_network_interface" "apigateway_vpce_enis" {
  count = length(local.ag_vpce_eni_ids)
  id    = local.ag_vpce_eni_ids[count.index]
}
