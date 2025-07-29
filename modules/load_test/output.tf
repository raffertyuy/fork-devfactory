output "load_test_id" {
  description = "The resource ID of the Azure Load Test"
  value       = azapi_resource.this.id
}

output "load_test_name" {
  description = "The name of the Azure Load Test"
  value       = azapi_resource.this.name
}

output "data_plane_uri" {
  description = "The data plane URI for the Azure Load Test"
  value       = try(azapi_resource.this.output.properties.dataPlaneURI, null)
}

output "provisioning_state" {
  description = "The provisioning state of the Azure Load Test"
  value       = try(azapi_resource.this.output.properties.provisioningState, null)
}

output "location" {
  description = "The Azure region where the load test is deployed"
  value       = azapi_resource.this.location
}

output "resource_group_name" {
  description = "The name of the resource group containing the load test"
  value       = var.resource_group_name
}

output "tags" {
  description = "The tags assigned to the load test resource"
  value       = azapi_resource.this.tags
}
