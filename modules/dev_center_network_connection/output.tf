output "id" {
  description = "The ID of the Dev Center Network Connection"
  value       = azurerm_dev_center_network_connection.this.id
}

output "name" {
  description = "The name of the Dev Center Network Connection"
  value       = azurerm_dev_center_network_connection.this.name
}

output "location" {
  description = "The location of the Dev Center Network Connection"
  value       = azurerm_dev_center_network_connection.this.location
}

output "resource_group_name" {
  description = "The resource group name of the Dev Center Network Connection"
  value       = azurerm_dev_center_network_connection.this.resource_group_name
}

output "domain_join_type" {
  description = "The domain join type of the Dev Center Network Connection"
  value       = azurerm_dev_center_network_connection.this.domain_join_type
}

output "subnet_id" {
  description = "The subnet ID of the Dev Center Network Connection"
  value       = azurerm_dev_center_network_connection.this.subnet_id
}