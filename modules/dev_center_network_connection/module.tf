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

resource "azapi_resource" "this" {
  type      = "Microsoft.DevCenter/networkConnections@2025-02-01"
  name      = local.network_connection_name
  location  = var.location
  parent_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}/resourceGroups/${var.resource_group_name}"

  body = {
    properties = merge(
      {
        domainJoinType = var.dev_center_network_connection.domain_join_type
        subnetId       = var.dev_center_network_connection.subnet_id
      },
      try(var.dev_center_network_connection.networking_resource_group_name, null) != null ? {
        networkingResourceGroupName = var.dev_center_network_connection.networking_resource_group_name
      } : {},
      try(var.dev_center_network_connection.domain_join.domain_name, null) != null ? {
        domainName = var.dev_center_network_connection.domain_join.domain_name
      } : {},
      try(var.dev_center_network_connection.domain_join.domain_username, null) != null ? {
        domainUsername = var.dev_center_network_connection.domain_join.domain_username
      } : {},
      try(var.dev_center_network_connection.domain_join.organizational_unit_path, null) != null ? {
        organizationUnit = var.dev_center_network_connection.domain_join.organizational_unit_path
      } : {}
    )
  }

  tags = local.tags

  response_export_values = ["properties"]

  # Ignore changes to system-managed tags that Azure automatically adds
  lifecycle {
    ignore_changes = [
      tags["hidden-title"]
    ]
  }
}

data "azapi_client_config" "current" {}