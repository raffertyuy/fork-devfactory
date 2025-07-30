output "id" {
  description = "The resource ID of the project environment type"
  value       = azapi_resource.this.id
}

output "name" {
  description = "The name of the project environment type"
  value       = azapi_resource.this.name
}

output "deployment_target_id" {
  description = "The deployment target subscription ID"
  value       = try(azapi_resource.this.output.properties.deploymentTargetId, null)
}

output "status" {
  description = "The status of the project environment type (Enabled/Disabled)"
  value       = try(azapi_resource.this.output.properties.status, null)
}

output "display_name" {
  description = "The display name of the project environment type"
  value       = try(azapi_resource.this.output.properties.displayName, null)
}

output "provisioning_state" {
  description = "The provisioning state of the project environment type"
  value       = try(azapi_resource.this.output.properties.provisioningState, null)
}

output "creator_role_assignment" {
  description = "The creator role assignments"
  value       = try(azapi_resource.this.output.properties.creatorRoleAssignment, null)
}

output "user_role_assignments" {
  description = "The user role assignments"
  value       = try(azapi_resource.this.output.properties.userRoleAssignments, null)
}

output "location" {
  description = "The location of the project environment type"
  value       = azapi_resource.this.location
}

output "tags" {
  description = "The tags assigned to the project environment type"
  value       = azapi_resource.this.tags
}
