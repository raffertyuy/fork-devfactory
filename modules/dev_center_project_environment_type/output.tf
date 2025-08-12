output "id" {
  description = "The ID of the Dev Center Project Environment Type"
  value       = azapi_resource.project_environment_type.id
}

output "name" {
  description = "The name of the Dev Center Project Environment Type"
  value       = azapi_resource.project_environment_type.name
}

output "location" {
  description = "The location of the Dev Center Project Environment Type"
  value       = azapi_resource.project_environment_type.location
}

output "dev_center_project_id" {
  description = "The ID of the Dev Center Project this environment type is associated with"
  value       = var.dev_center_project_id
}

output "deployment_target_id" {
  description = "The ID of the deployment target for this environment type"
  value       = var.deployment_target_id
}

output "status" {
  description = "The status of the Dev Center Project Environment Type"
  value       = try(jsondecode(azapi_resource.project_environment_type.output).properties.status, null)
}

output "display_name" {
  description = "The display name of the Dev Center Project Environment Type"
  value       = try(jsondecode(azapi_resource.project_environment_type.output).properties.displayName, null)
}

output "provisioning_state" {
  description = "The provisioning state of the Dev Center Project Environment Type"
  value       = try(jsondecode(azapi_resource.project_environment_type.output).properties.provisioningState, null)
}

output "tags" {
  description = "The tags assigned to the Dev Center Project Environment Type"
  value       = azapi_resource.project_environment_type.tags
}