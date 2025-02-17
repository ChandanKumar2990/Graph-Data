output "eclipse_neptune_security_group" {
  value = aws_security_group.eclipse_neptune_security_group.id
}

output "selected_subnet_cidrs" {
  value = [for s in data.aws_subnet.selected_subnet : s.cidr_blocks]
}

output "default_subnet_cidrs" {
  value = [for s in data.aws_subnet.selected_subnet : s.cidr_blocks]
}

output "selected_subnet_ids" {
  value = tolist(data.aws_subnets.private_subnets[var.network_type["selected_tier"]["network_type"]].ids)
}

output "default_subnet_ids" {
  value = tolist(data.aws_subnets.private_subnets[var.network_type["default_tier"]["network_type"]].ids)
}

output "base_sg_id" {
  value = tolist(data.aws_security_groups.base.ids)
}

output "default_sg_id" {
  value = tolist(data.aws_security_groups.base.ids)
}

output "apigateway_vpc_endpoint_details" {
  value = {
    id             = data.aws_vpc_endpoint.api_interface_endpoint.id
    eni_ip_address = [for ip in data.aws_network_interface.apigateway_vpce_enis : ip.private_ip]
  }
}
