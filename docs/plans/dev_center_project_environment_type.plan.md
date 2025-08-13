# Implementation Plan for Dev Center Project Environment Type Module

## Overview

This plan outlines the implementation of the `dev_center_project_environment_type` module for DevFactory. This module will link environment types to projects within an Azure Dev Center, enabling the association of specific environment definitions with development projects.

The module will create Azure DevCenter Project Environment Type resources using the AzAPI provider v2.4.0, following established DevFactory patterns for consistency, naming conventions, and integration with the existing module ecosystem.

## Implementation Steps

- [x] **Step 1: Create Module Infrastructure**
  - **Task**: Create the core module structure and files for dev_center_project_environment_type following DevFactory patterns
  - **Files**:
    - `modules/dev_center_project_environment_type/module.tf`: Main module implementation with azapi_resource for Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview
    - `modules/dev_center_project_environment_type/variables.tf`: Input variable definitions with strong typing and validation
    - `modules/dev_center_project_environment_type/output.tf`: Output definitions for project environment type properties
    - `modules/dev_center_project_environment_type/README.md`: Module documentation with usage examples
  - **Dependencies**: AzAPI provider v2.4.0, azurecaf provider for naming
  - **Pseudocode**:

    ```hcl
    resource "azurecaf_name" "project_environment_type" {
      name          = var.project_environment_type.name
      resource_type = "general"
      prefixes      = var.global_settings.prefixes
      # ... other naming settings
    }

    resource "azapi_resource" "project_environment_type" {
      type      = "Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview"
      name      = azurecaf_name.project_environment_type.result
      parent_id = var.dev_center_project_id
      body = {
        properties = {
          environmentTypeName = var.environment_type_name
          deploymentTargetId  = var.deployment_target_id
          # ... other properties
        }
        tags = local.tags
      }
    }
    ```

- [x] **Step 2: Create Root Orchestration File**
  - **Task**: Create the root-level orchestration file to manage project environment types across all projects
  - **Files**:
    - `dev_center_project_environment_types.tf`: Root orchestration calling the project environment type module for each configuration
  - **Dependencies**: dev_center_project_environment_type module, dev_center_projects module for references
  - **Pseudocode**:

    ```hcl
    module "dev_center_project_environment_types" {
      source   = "./modules/dev_center_project_environment_type"
      for_each = var.dev_center_project_environment_types

      global_settings          = var.global_settings
      project_environment_type = each.value
      location                 = lookup(each.value, "location", null) != null ? each.value.location : module.resource_groups[each.value.resource_group.key].location
      dev_center_project_id    = lookup(each.value, "dev_center_project_id", null) != null ? each.value.dev_center_project_id : module.dev_center_projects[each.value.project.key].id
      deployment_target_id     = each.value.deployment_target_id
    }
    ```

- [x] **Step 3: Add Variable Definition**
  - **Task**: Add the dev_center_project_environment_types variable to the root variables.tf
  - **Files**:
    - `variables.tf`: Add strongly-typed variable definition with validation
  - **Dependencies**: None
  - **Pseudocode**:

    ```hcl
    variable "dev_center_project_environment_types" {
      description = "Dev Center Project Environment Types configuration objects"
      type = map(object({
        name = string
        project = object({
          key = string
        })
        environment_type = object({
          key = string
        })
        deployment_target_id = string
        location = optional(string)
        tags = optional(map(string), {})
      }))
      default = {}
    }
    ```

- [x] **Step 4: Create Example Implementation**
  - **Task**: Create a complete working example demonstrating the module usage
  - **Files**:
    - `examples/dev_center_project_environment_type/configuration.tfvars`: Example configuration showing realistic usage
  - **Dependencies**: Requires existing dev_center and dev_center_project examples as foundation
  - **Pseudocode**:

    ```hcl
    global_settings = {
      prefixes      = ["dev"]
      random_length = 3
      passthrough   = false
      use_slug      = true
    }

    dev_center_project_environment_types = {
      projenvtype1 = {
        name = "terraform-env"
        project = {
          key = "project1"
        }
        environment_type = {
          key = "envtype1"
        }
        deployment_target_id = "/subscriptions/xxx/resourceGroups/xxx/providers/Microsoft.Resources/deploymentTargets/xxx"
        tags = {
          environment = "demo"
        }
      }
    }
    ```

- [x] **Step 5: Create Unit Tests**
  - **Task**: Implement comprehensive unit tests following Terraform testing patterns
  - **Files**:
    - `tests/unit/dev_center_project_environment_type/project_environment_type_test.tftest.hcl`: Unit tests with provider mocking
  - **Dependencies**: Test infrastructure, mock providers
  - **Pseudocode**:

    ```hcl
    mock_provider "azapi" {}
    mock_provider "azurecaf" {}

    run "test_project_environment_type_creation" {
      command = plan
      
      assert {
        condition     = module.dev_center_project_environment_types["projenvtype1"] != null
        error_message = "Project environment type module should exist"
      }
    }
    ```

- [x] **Step 6: Update Documentation**
  - **Task**: Update project documentation to reflect the new module
  - **Files**:
    - `docs/file_structure.md`: Add description of new files and directories
    - `CHANGES_SUMMARY.md`: Document the implementation as a new feature
  - **Dependencies**: None
  - **User Intervention Required**: Review documentation for accuracy and completeness

## Validation Criteria

1. **Module Functionality**: Project environment types are linked successfully to projects with correct API version and properties
2. **Naming Conventions**: azurecaf naming is applied consistently following project patterns
3. **Input Validation**: Strong typing and validation rules prevent invalid configurations
4. **Example Completeness**: Examples demonstrate realistic usage scenarios
5. **Test Coverage**: Unit tests cover basic functionality and edge cases
6. **Documentation Quality**: All documentation is clear, accurate, and follows project standards
7. **Integration**: Module integrates properly with existing Dev Center infrastructure

## Risk Mitigation

- **API Compatibility**: Using the latest stable API version (2025-04-01-preview) for future compatibility
- **Breaking Changes**: Following established patterns ensures minimal impact on existing configurations
- **Testing**: Comprehensive test coverage ensures reliability and prevents regressions
- **Documentation**: Clear documentation facilitates adoption and maintenance

## User Intervention Required

- **Step 6**: Review and approve documentation updates
- **Final Testing**: User should run `/3-apply dev_center_project_environment_type` for full integration testing
- **Validation**: User should verify the module works with their specific Azure subscription and environment setup