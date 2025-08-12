output "id" {
  description = "The ID of the Dev Center Network Connection"
  value       = azapi_resource.this.id
}

output "name" {
  description = "The name of the Dev Center Network Connection"
  value       = azapi_resource.this.name
}

output "location" {
  description = "The location of the Dev Center Network Connection"
  value       = azapi_resource.this.location
}

output "resource_group_name" {
  description = "The resource group name of the Dev Center Network Connection"
  value       = var.resource_group_name
}

output "domain_join_type" {
  description = "The domain join type of the Dev Center Network Connection"
  value       = try(azapi_resource.this.output.properties.domainJoinType, null)
}

output "subnet_id" {
  description = "The subnet ID of the Dev Center Network Connection"
  value       = try(azapi_resource.this.output.properties.subnetId, null)
}

output "provisioning_state" {
  description = "The provisioning state of the Dev Center Network Connection"
  value       = try(azapi_resource.this.output.properties.provisioningState, null)
}

output "health_check_status" {
  description = "The health check status of the Dev Center Network Connection"
  value       = try(azapi_resource.this.output.properties.healthCheckStatus, null)
}