terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.29"
    }
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4.0"
    }
  }
}

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.environment_type.tags, {})
  )
}

# Using resource instead of data source to ensure stable naming across plan/apply
resource "azurecaf_name" "environment_type" {
  name          = var.environment_type.name
  resource_type = "azurerm_dev_center_environment_type"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azapi_resource" "dev_center_environment_type" {
  type      = "Microsoft.DevCenter/devcenters/environmentTypes@2025-04-01-preview"
  name      = azurecaf_name.environment_type.result
  parent_id = var.dev_center_id

  body = {
    properties = merge(
      try(var.environment_type.display_name, null) != null ? {
        displayName = var.environment_type.display_name
      } : {}
    )
    tags = local.tags
  }

  response_export_values = ["properties"]

  # Ignore changes to system-managed tags that Azure automatically adds
  lifecycle {
    ignore_changes = [
      tags["hidden-title"]
    ]
  }
}
