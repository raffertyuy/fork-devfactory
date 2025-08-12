# DevCenter Project Environment Type Module Outputs

output "id" {
  description = "The ID of the DevCenter project environment type"
  value       = azapi_resource.dev_center_project_environment_type.id
}

output "name" {
  description = "The name of the DevCenter project environment type"
  value       = azapi_resource.dev_center_project_environment_type.name
}

output "resource_id" {
  description = "The full resource ID of the DevCenter project environment type"
  value       = azapi_resource.dev_center_project_environment_type.id
}

output "properties" {
  description = "The properties of the DevCenter project environment type"
  value       = azapi_resource.dev_center_project_environment_type.output
  sensitive   = false
}

output "dev_center_project_id" {
  description = "The ID of the parent Dev Center Project"
  value       = var.dev_center_project_id
}

output "environment_type_id" {
  description = "The ID of the linked environment type"
  value       = var.environment_type_id
}

output "deployment_target_id" {
  description = "The deployment target ID for environments of this type"
  value       = var.deployment_target_id
}

output "display_name" {
  description = "The display name of the project environment type"
  value       = try(azapi_resource.dev_center_project_environment_type.output.properties.displayName, local.environment_type_name)
}

output "status" {
  description = "The status of the project environment type"
  value       = try(azapi_resource.dev_center_project_environment_type.output.properties.status, null)
}

output "provisioning_state" {
  description = "The provisioning state of the project environment type"
  value       = try(azapi_resource.dev_center_project_environment_type.output.properties.provisioningState, null)
}

output "tags" {
  description = "The tags applied to the DevCenter project environment type"
  value       = azapi_resource.dev_center_project_environment_type.tags
}