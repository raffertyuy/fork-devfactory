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
    try(var.project_environment_type.tags, {})
  )
}

resource "azurecaf_name" "project_environment_type" {
  name          = var.project_environment_type.name
  resource_type = "azurerm_dev_center_project_environment_type"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

resource "azapi_resource" "this" {
  type      = "Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview"
  name      = azurecaf_name.project_environment_type.result
  parent_id = var.project_id
  location  = var.location
  tags      = local.tags

  dynamic "identity" {
    for_each = try(var.project_environment_type.identity, null) != null ? [var.project_environment_type.identity] : []
    content {
      type         = identity.value.type
      identity_ids = try(identity.value.identity_ids, [])
    }
  }

  body = {
    properties = merge(
      {
        deploymentTargetId = var.project_environment_type.deployment_target_id
        status             = try(var.project_environment_type.status, "Enabled")
      },
      try(var.project_environment_type.display_name, null) != null ? {
        displayName = var.project_environment_type.display_name
      } : {},
      try(var.project_environment_type.creator_role_assignment, null) != null ? {
        creatorRoleAssignment = var.project_environment_type.creator_role_assignment
      } : {},
      try(var.project_environment_type.user_role_assignments, null) != null ? {
        userRoleAssignments = var.project_environment_type.user_role_assignments
      } : {}
    )
  }

  response_export_values = ["properties"]

  # Ignore changes to system-managed tags that Azure automatically adds
  lifecycle {
    ignore_changes = [
      body.tags
    ]
  }
}
