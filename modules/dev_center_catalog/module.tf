terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.26.0"
    }
  }
}

locals {}

resource "azurecaf_name" "catalog" {
  name          = var.catalog.name
  resource_type = "general"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azurerm_dev_center_catalog" "catalog" {
  name                = azurecaf_name.catalog.result
  resource_group_name = var.resource_group_name
  dev_center_id       = var.dev_center_id

  dynamic "catalog_github" {
    for_each = try(var.catalog.catalog_github, null) != null ? [var.catalog.catalog_github] : []
    content {
      uri               = catalog_github.value.uri
      branch            = catalog_github.value.branch
      path              = catalog_github.value.path
      key_vault_key_url = catalog_github.value.key_vault_key_url
    }
  }

  dynamic "catalog_adogit" {
    for_each = try(var.catalog.catalog_adogit, null) != null ? [var.catalog.catalog_adogit] : []
    content {
      uri               = catalog_adogit.value.uri
      branch            = catalog_adogit.value.branch
      path              = catalog_adogit.value.path
      key_vault_key_url = catalog_adogit.value.key_vault_key_url
    }
  }
}
