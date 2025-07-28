output "id" {
  description = "The ID of the Dev Center Environment Type"
  value       = azapi_resource.dev_center_environment_type.id
}

output "name" {
  description = "The name of the Dev Center Environment Type"
  value       = azapi_resource.dev_center_environment_type.name
}

output "dev_center_id" {
  description = "The ID of the parent Dev Center"
  value       = var.dev_center_id
}

output "display_name" {
  description = "The display name of the Dev Center Environment Type"
  value       = try(azapi_resource.dev_center_environment_type.output.properties.displayName, null)
}

output "provisioning_state" {
  description = "The provisioning state of the Dev Center Environment Type"
  value       = try(azapi_resource.dev_center_environment_type.output.properties.provisioningState, null)
}
