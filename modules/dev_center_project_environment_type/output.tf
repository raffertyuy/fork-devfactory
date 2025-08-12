output "id" {
  description = "The ID of the Dev Center Project Environment Type"
  value       = azapi_resource.dev_center_project_environment_type.id
}

output "name" {
  description = "The name of the Dev Center Project Environment Type"
  value       = azapi_resource.dev_center_project_environment_type.name
}

output "dev_center_project_id" {
  description = "The ID of the parent Dev Center Project"
  value       = var.dev_center_project_id
}

output "environment_type_name" {
  description = "The name of the environment type linked to this project"
  value       = var.project_environment_type.environment_type_name
}

output "deployment_target_id" {
  description = "The deployment target ID for this project environment type"
  value       = var.project_environment_type.deployment_target_id
}

output "location" {
  description = "The location of the Dev Center Project Environment Type"
  value       = var.location
}

output "provisioning_state" {
  description = "The provisioning state of the Dev Center Project Environment Type"
  value       = try(azapi_resource.dev_center_project_environment_type.output.properties.provisioningState, null)
}