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

# Data source to get current subscription information
data "azapi_client_config" "current" {}

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.dev_box_definition.tags, {}),
    try(var.tags, {})
  )
  # Process image reference ID - handle both absolute and relative formats
  processed_image_reference_id = try(var.dev_box_definition.image_reference_id, null) != null ? (
    # If it starts with /subscriptions, it's an absolute path - replace subscription-id placeholder
    startswith(var.dev_box_definition.image_reference_id, "/subscriptions") ? replace(
      var.dev_box_definition.image_reference_id,
      "subscription-id",
      data.azapi_client_config.current.subscription_id
      ) : (
      # If it starts with galleries/, it's relative to the dev center
      startswith(var.dev_box_definition.image_reference_id, "galleries/") ?
      "${var.dev_center_id}/${var.dev_box_definition.image_reference_id}" :
      # Otherwise, assume it's a complete reference
      var.dev_box_definition.image_reference_id
    )
  ) : null
  # Process image reference object if provided
  processed_image_reference = try(var.dev_box_definition.image_reference, null) != null ? {
    id = startswith(var.dev_box_definition.image_reference.id, "/subscriptions") ? replace(
      var.dev_box_definition.image_reference.id,
      "subscription-id",
      data.azapi_client_config.current.subscription_id
      ) : (
      startswith(var.dev_box_definition.image_reference.id, "galleries/") ?
      "${var.dev_center_id}/${var.dev_box_definition.image_reference.id}" :
      var.dev_box_definition.image_reference.id
    )
  } : null

  # Build SKU object for advanced configuration - filter null values to avoid type issues
  sku_object = var.dev_box_definition.sku != null ? merge(
    {
      name = var.dev_box_definition.sku.name
    },
    var.dev_box_definition.sku.capacity != null ? { capacity = var.dev_box_definition.sku.capacity } : {},
    var.dev_box_definition.sku.family != null ? { family = var.dev_box_definition.sku.family } : {},
    var.dev_box_definition.sku.size != null ? { size = var.dev_box_definition.sku.size } : {},
    var.dev_box_definition.sku.tier != null ? { tier = var.dev_box_definition.sku.tier } : {}
  ) : null
}

resource "azurecaf_name" "dev_box_definition" {
  name          = var.dev_box_definition.name
  resource_type = "azurerm_dev_center_dev_box_definition"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azapi_resource" "dev_box_definition" {
  type                   = "Microsoft.DevCenter/devcenters/devboxdefinitions@2025-04-01-preview"
  name                   = azurecaf_name.dev_box_definition.result
  location               = var.location
  parent_id              = var.dev_center_id
  tags                   = local.tags
  response_export_values = ["properties.provisioningState", "properties.imageReference", "properties.sku"]

  # Enable schema validation
  schema_validation_enabled = true
  body = {
    properties = merge(
      # Image reference configuration
      local.processed_image_reference != null ? {
        imageReference = local.processed_image_reference
        } : local.processed_image_reference_id != null ? {
        imageReference = {
          id = local.processed_image_reference_id
        }
      } : {},

      # SKU configuration - supports both simple name and full object
      local.sku_object != null ? {
        sku = local.sku_object
        } : var.dev_box_definition.sku_name != null ? {
        sku = {
          name = var.dev_box_definition.sku_name
        }
      } : {},

      # OS Storage Type configuration
      try(var.dev_box_definition.os_storage_type, null) != null ? {
        osStorageType = var.dev_box_definition.os_storage_type
      } : {},

      # Hibernate support configuration
      var.dev_box_definition.hibernate_support != null ? {
        hibernateSupport = var.dev_box_definition.hibernate_support ? "Enabled" : "Disabled"
      } : {}
    )
  }
}