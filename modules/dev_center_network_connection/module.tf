terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.29"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.dev_center_network_connection.tags, {})
  )

  # Ensure Dev Center Network Connection name follows naming conventions
  network_connection_name = azurecaf_name.dev_center_network_connection.result
}

# Using resource instead of data source to ensure stable naming across plan/apply
resource "azurecaf_name" "dev_center_network_connection" {
  name          = var.dev_center_network_connection.name
  resource_type = "azurerm_dev_center_network_connection"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_dev_center_network_connection" "this" {
  name                = local.network_connection_name
  resource_group_name = var.resource_group_name
  location            = var.location
  domain_join_type    = var.dev_center_network_connection.domain_join_type
  subnet_id           = var.dev_center_network_connection.subnet_id

  domain_name       = try(var.dev_center_network_connection.domain_name, null)
  domain_password   = try(var.dev_center_network_connection.domain_password, null)
  domain_username   = try(var.dev_center_network_connection.domain_username, null)
  organization_unit = try(var.dev_center_network_connection.organization_unit, null)

  tags = local.tags

  # Ignore changes to system-managed tags that Azure automatically adds
  lifecycle {
    ignore_changes = [
      tags["hidden-title"]
    ]
  }
}