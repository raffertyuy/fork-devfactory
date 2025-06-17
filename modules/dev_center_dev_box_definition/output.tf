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

output "tags" {
  description = "The tags assigned to the DevBox Definition"
  value       = azapi_resource.dev_box_definition.tags
}
