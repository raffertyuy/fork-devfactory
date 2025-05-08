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

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.catalog.tags, {}),
    try(var.tags, {})
  )
}

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
  name          = azurecaf_name.catalog.result
  dev_center_id = var.dev_center_id

  # Optional properties for GitHub integration (new style)
  dynamic "git_hub" {
    for_each = try(var.catalog.git_hub, null) != null ? [1] : []
    content {
      uri               = var.catalog.git_hub.uri
      branch            = try(var.catalog.git_hub.branch, null)
      path              = try(var.catalog.git_hub.path, null)
      secret_identifier = try(var.catalog.git_hub.secret_identifier, null)
    }
  }

  # Optional properties for GitHub integration (legacy style)
  dynamic "git_hub" {
    for_each = try(var.catalog.catalog_github, null) != null ? [1] : []
    content {
      uri               = var.catalog.catalog_github.uri
      branch            = var.catalog.catalog_github.branch
      path              = var.catalog.catalog_github.path
      secret_identifier = var.catalog.catalog_github.key_vault_key_url
    }
  }

  # Optional properties for Azure DevOps integration (new style)
  dynamic "ado_git" {
    for_each = try(var.catalog.ado_git, null) != null ? [1] : []
    content {
      uri               = var.catalog.ado_git.uri
      branch            = try(var.catalog.ado_git.branch, null)
      path              = try(var.catalog.ado_git.path, null)
      secret_identifier = try(var.catalog.ado_git.secret_identifier, null)
    }
  }

  # Optional properties for Azure DevOps integration (legacy style)
  dynamic "ado_git" {
    for_each = try(var.catalog.catalog_adogit, null) != null ? [1] : []
    content {
      uri               = var.catalog.catalog_adogit.uri
      branch            = var.catalog.catalog_adogit.branch
      path              = var.catalog.catalog_adogit.path
      secret_identifier = var.catalog.catalog_adogit.key_vault_key_url
    }
  }

  # Optional sync_type property
  sync_type = try(var.catalog.sync_type, null)

  tags = local.tags
}
