# RestAPI ID

output "eclipse_data_restapi_id" {
  value = var.create_api_resources ? aws_api_gateway_rest_api.eclipse_data_restapi[0].id : ""
}

# RestAPI Resource ID

output "eclipse_data_restapi_root_resource_id" {
  value = var.create_api_resources ? aws_api_gateway_rest_api.eclipse_data_restapi[0].root_resource_id : ""
}
