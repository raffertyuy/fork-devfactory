# DevCenter Project Environment Type Module
# This module links environment types to Azure DevCenter projects using the AzAPI provider
# Following Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview schema

terraform {
  required_version = ">= 1.9.0"
  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.4.0"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~> 1.2.29"
    }
  }
}

locals {
  tags = merge(
    try(var.global_settings.tags, {}),
    try(var.project_environment_type.tags, {}),
    {
      terraform-azapi-resource-type = "Microsoft.DevCenter/projects/environmentTypes"
      terraform-azapi-version       = "2025-04-01-preview"
    }
  )
}

# Extract environment type name from the environment type ID for the resource name
locals {
  environment_type_name = element(split("/", var.environment_type_id), length(split("/", var.environment_type_id)) - 1)
}

resource "azurecaf_name" "project_environment_type" {
  name          = local.environment_type_name
  resource_type = "azurerm_dev_center_environment_type"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = var.global_settings.use_slug
}

# DevCenter Project Environment Type Resource
resource "azapi_resource" "dev_center_project_environment_type" {
  type      = "Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview"
  name      = local.environment_type_name
  parent_id = var.dev_center_project_id
  location  = var.location

  body = {
    properties = {
      # Environment type reference (required)
      environmentTypeId = var.environment_type_id
      
      # Deployment target configuration
      deploymentTargetId = var.deployment_target_id
      
      # Optional status setting
      status = try(var.project_environment_type.status, "Enabled")
      
      # Optional role assignments for environment creators
      creatorRoleAssignment = try(var.project_environment_type.creator_role_assignment, null) != null ? {
        roles = var.project_environment_type.creator_role_assignment.roles
      } : null
    }
  }

  # Conditional tags - merge global tags with resource-specific tags
  tags = local.tags

  response_export_values = ["properties"]

  # Ignore changes to certain computed properties and Azure-managed tags
  lifecycle {
    ignore_changes = [
      body.properties.provisioningState,
      tags["hidden-title"]
    ]
  }
}