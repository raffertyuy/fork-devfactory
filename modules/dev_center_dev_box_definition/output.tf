output "id" {
  description = "The ID of the DevBox Definition"
  value       = azapi_resource.dev_box_definition.id
}

output "name" {
  description = "The name of the DevBox Definition"
  value       = azapi_resource.dev_box_definition.name
}

output "dev_center_id" {
  description = "The ID of the Dev Center"
  value       = var.dev_center_id
}

output "provisioning_state" {
  description = "The provisioning state of the DevBox Definition"
  value       = try(azapi_resource.dev_box_definition.output.properties.provisioningState, null)
}

output "image_reference" {
  description = "The image reference configuration"
  value       = try(azapi_resource.dev_box_definition.output.properties.imageReference, null)
}

output "sku" {
  description = "The SKU configuration"
  value       = try(azapi_resource.dev_box_definition.output.properties.sku, null)
}



output "hibernate_support" {
  description = "The hibernate support status"
  value       = try(azapi_resource.dev_box_definition.output.properties.hibernateSupport, null)
}

output "os_storage_type" {
  description = "The storage type used for the Operating System disk"
  value       = try(azapi_resource.dev_box_definition.output.properties.osStorageType, null)
}

output "image_validation_status" {
  description = "Validation status of the configured image"
  value       = try(azapi_resource.dev_box_definition.output.properties.imageValidationStatus, null)
}

output "image_validation_error_details" {
  description = "Details for image validator error"
  value       = try(azapi_resource.dev_box_definition.output.properties.imageValidationErrorDetails, null)
}

output "validation_status" {
  description = "Validation status for the Dev Box Definition"
  value       = try(azapi_resource.dev_box_definition.output.properties.validationStatus, null)
}

output "active_image_reference" {
  description = "Image reference information for the currently active image"
  value       = try(azapi_resource.dev_box_definition.output.properties.activeImageReference, null)
}

output "tags" {
  description = "The tags assigned to the DevBox Definition"
  value       = azapi_resource.dev_box_definition.tags
}
