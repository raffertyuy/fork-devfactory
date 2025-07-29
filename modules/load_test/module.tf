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

# Data source for current Azure configuration
data "azapi_client_config" "current" {}

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.load_test.tags, {})
  )
}

# Generate consistent naming using azurecaf
resource "azurecaf_name" "this" {
  name          = var.load_test.name
  resource_type = "azurerm_load_test"
  prefixes      = var.global_settings.prefixes
  suffixes      = var.global_settings.suffixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
  separator     = var.global_settings.separator
}

# Azure Load Test resource
resource "azapi_resource" "this" {
  type      = "Microsoft.LoadTestService/loadTests@2024-12-01-preview"
  name      = azurecaf_name.this.result
  location  = var.location
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"

  # Identity configuration - only included when identity is specified
  dynamic "identity" {
    for_each = try(var.load_test.identity, null) != null ? [var.load_test.identity] : []
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, null)
    }
  }

  body = {
    properties = {
      description = try(var.load_test.description, null)
      encryption = try(var.load_test.encryption, null) != null ? {
        identity = try(var.load_test.encryption.identity, null) != null ? {
          type       = try(var.load_test.encryption.identity.type, null)
          resourceId = try(var.load_test.encryption.identity.resource_id, null)
        } : null
        keyUrl = try(var.load_test.encryption.key_url, null)
      } : null
    }
  }

  tags = local.tags

  response_export_values = ["properties"]
}
