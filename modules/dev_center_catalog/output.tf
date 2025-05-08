output "id" {
  description = "The ID of the Dev Center Catalog"
  value       = azurerm_dev_center_catalog.catalog.id
}

output "name" {
  description = "The name of the Dev Center Catalog"
  value       = azurerm_dev_center_catalog.catalog.name
}

output "connection_state" {
  description = "The connection state of the Dev Center Catalog"
  value       = azurerm_dev_center_catalog.catalog.connection_state
}

output "sync_state" {
  description = "The synchronization state of the Dev Center Catalog"
  value       = azurerm_dev_center_catalog.catalog.sync_state
}

output "last_sync_time" {
  description = "The time when the Dev Center Catalog was last synced"
  value       = azurerm_dev_center_catalog.catalog.last_sync_time
}
