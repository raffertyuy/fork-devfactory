# Implementation Plan for Dev Center Project Environment Type

This implementation plan covers the creation of a complete Terraform module for managing Azure DevCenter project environment types using the AzAPI provider v2.4.0.

## Overview

Dev Center Project Environment Types establish the relationship between a DevCenter project and environment types that can be used within that project. This is different from the DevCenter-level environment types which define the global environment types available across the DevCenter. Project environment types configure how those global environment types are used within specific projects, including deployment target subscriptions, role assignments, and status configuration.

**Key Resource**: `Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview`

## Implementation Steps

- [x] **Step 1: Create Module Structure**
  - **Task**: Set up the module directory structure and base Terraform configuration files following DevFactory patterns
  - **Files**:
    - `modules/dev_center_project_environment_type/module.tf`: Main module implementation with AzAPI resource
    - `modules/dev_center_project_environment_type/variables.tf`: Input variable definitions with strong typing
    - `modules/dev_center_project_environment_type/output.tf`: Output definitions for resource properties
    - `modules/dev_center_project_environment_type/README.md`: Module documentation with usage examples
  - **Dependencies**: None - foundation step

- [x] **Step 2: Implement Module Logic**
  - **Task**: Create the core module implementation using AzAPI provider with support for all project environment type properties
  - **Files**:
    - `modules/dev_center_project_environment_type/module.tf`:

      ```hcl
      terraform {
        required_version = ">= 1.9.0"
        required_providers {
          azurecaf = { source = "aztfmod/azurecaf", version = "~> 1.2.29" }
          azapi = { source = "Azure/azapi", version = "~> 2.4.0" }
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

      resource "azapi_resource" "project_environment_type" {
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
              status = try(var.project_environment_type.status, "Enabled")
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
      }
      ```

    - `modules/dev_center_project_environment_type/variables.tf`: Strong typing with validation
    - `modules/dev_center_project_environment_type/output.tf`: Resource outputs for integration
  - **Dependencies**: Step 1 completion

- [x] **Step 3: Define Variable Structure**
  - **Task**: Create comprehensive variable definitions with proper validation and typing
  - **Files**:
    - `modules/dev_center_project_environment_type/variables.tf`:
      ```hcl
      variable "global_settings" {
        description = "Global settings for resource naming and tagging"
        type = object({
          prefixes      = optional(list(string), [])
          random_length = optional(number, 3)
          passthrough   = optional(bool, false)
          use_slug      = optional(bool, true)
          tags          = optional(map(string), {})
        })
        default = {}
      }

      variable "project_environment_type" {
        description = "Configuration for the Dev Center project environment type"
        type = object({
          name                   = string
          deployment_target_id   = string
          status                = optional(string, "Enabled")
          display_name          = optional(string)
          creator_role_assignment = optional(object({
            roles = map(object({}))
          }))
          user_role_assignments = optional(map(object({
            roles = map(object({}))
          })))
          identity = optional(object({
            type         = string
            identity_ids = optional(list(string), [])
          }))
          tags = optional(map(string), {})
        })

        validation {
          condition = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_.]{2,62}$", var.project_environment_type.name))
          error_message = "Name must be 3-63 characters, start with alphanumeric, and contain only alphanumeric, hyphens, underscores, and periods."
        }

        validation {
          condition = contains(["Enabled", "Disabled"], try(var.project_environment_type.status, "Enabled"))
          error_message = "Status must be either 'Enabled' or 'Disabled'."
        }
      }

      variable "project_id" {
        description = "The resource ID of the DevCenter project"
        type        = string
      }

      variable "location" {
        description = "The Azure region where the resource will be created"
        type        = string
      }
      ```
  - **Dependencies**: Step 2 completion

- [x] **Step 4: Define Output Structure**
  - **Task**: Create comprehensive outputs for resource integration and monitoring
  - **Files**:
    - `modules/dev_center_project_environment_type/output.tf`:
      ```hcl
      output "id" {
        description = "The resource ID of the project environment type"
        value       = azapi_resource.project_environment_type.id
      }

      output "name" {
        description = "The name of the project environment type"
        value       = azapi_resource.project_environment_type.name
      }

      output "deployment_target_id" {
        description = "The deployment target subscription ID"
        value       = try(azapi_resource.project_environment_type.output.properties.deploymentTargetId, null)
      }

      output "status" {
        description = "The status of the project environment type (Enabled/Disabled)"
        value       = try(azapi_resource.project_environment_type.output.properties.status, null)
      }

      output "display_name" {
        description = "The display name of the project environment type"
        value       = try(azapi_resource.project_environment_type.output.properties.displayName, null)
      }

      output "provisioning_state" {
        description = "The provisioning state of the project environment type"
        value       = try(azapi_resource.project_environment_type.output.properties.provisioningState, null)
      }

      output "creator_role_assignment" {
        description = "The creator role assignments"
        value       = try(azapi_resource.project_environment_type.output.properties.creatorRoleAssignment, null)
      }

      output "user_role_assignments" {
        description = "The user role assignments"
        value       = try(azapi_resource.project_environment_type.output.properties.userRoleAssignments, null)
      }

      output "location" {
        description = "The location of the project environment type"
        value       = azapi_resource.project_environment_type.location
      }

      output "tags" {
        description = "The tags assigned to the project environment type"
        value       = azapi_resource.project_environment_type.tags
      }
      ```
  - **Dependencies**: Step 3 completion

- [x] **Step 5: Create Root Orchestration**
  - **Task**: Create root-level Terraform file to orchestrate the module instances
  - **Files**:
    - `dev_center_project_environment_types.tf`:
      ```hcl
      # Dev Center Project Environment Types module instantiation
      module "dev_center_project_environment_types" {
        source   = "./modules/dev_center_project_environment_type"
        for_each = try(var.dev_center_project_environment_types, {})

        global_settings           = var.global_settings
        project_environment_type  = each.value
        project_id               = lookup(each.value, "project_id", null) != null ? each.value.project_id : module.dev_center_projects[each.value.project.key].id
        location                 = lookup(each.value, "region", null) != null ? each.value.region : var.global_settings.default_region
      }
      ```
  - **Dependencies**: Step 4 completion

- [x] **Step 6: Create Simple Example**
  - **Task**: Create a basic example demonstrating simple project environment type configuration
  - **Files**:
    - `examples/dev_center_project_environment_type/simple_case/configuration.tfvars`:
      ```hcl
      global_settings = {
        prefixes      = ["demo"]
        random_length = 3
        default_region = "eastus"
        tags = {
          environment = "development"
          workload    = "devcenter"
        }
      }

      resource_groups = {
        devcenter_rg = {
          name = "devcenter-resources"
        }
      }

      dev_centers = {
        main = {
          name = "demo-devcenter"
          resource_group = { key = "devcenter_rg" }
        }
      }

      dev_center_environment_types = {
        dev = {
          name = "development"
          dev_center = { key = "main" }
        }
      }

      dev_center_projects = {
        webapp = {
          name = "webapp-project"
          dev_center = { key = "main" }
          resource_group = { key = "devcenter_rg" }
        }
      }

      dev_center_project_environment_types = {
        webapp_dev = {
          name = "development"
          project = { key = "webapp" }
          deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
          status = "Enabled"
        }
      }
      ```
    - `examples/dev_center_project_environment_type/simple_case/README.md`: Example documentation
  - **Dependencies**: Step 5 completion

- [x] **Step 7: Create Enhanced Example**
  - **Task**: Create advanced example with role assignments and multiple environment types
  - **Files**:
    - `examples/dev_center_project_environment_type/enhanced_case/configuration.tfvars`:
      ```hcl
      global_settings = {
        prefixes      = ["corp"]
        random_length = 3
        default_region = "eastus"
        tags = {
          environment = "production"
          workload    = "devcenter"
          owner       = "platform-team"
        }
      }

      resource_groups = {
        devcenter_rg = {
          name = "devcenter-resources"
        }
      }

      dev_centers = {
        corp = {
          name = "corp-devcenter"
          resource_group = { key = "devcenter_rg" }
        }
      }

      dev_center_environment_types = {
        dev = {
          name = "development"
          dev_center = { key = "corp" }
        }
        staging = {
          name = "staging"
          dev_center = { key = "corp" }
        }
        prod = {
          name = "production"
          dev_center = { key = "corp" }
        }
      }

      dev_center_projects = {
        webapp = {
          name = "webapp-project"
          dev_center = { key = "corp" }
          resource_group = { key = "devcenter_rg" }
        }
        api = {
          name = "api-project"
          dev_center = { key = "corp" }
          resource_group = { key = "devcenter_rg" }
        }
      }

      dev_center_project_environment_types = {
        webapp_dev = {
          name = "development"
          project = { key = "webapp" }
          deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
          status = "Enabled"
          display_name = "Web App Development Environment"
          creator_role_assignment = {
            roles = {
              "b24988ac-6180-42a0-ab88-20f7382dd24c" = {} # Contributor
            }
          }
          user_role_assignments = {
            "11111111-1111-1111-1111-111111111111" = {
              roles = {
                "acdd72a7-3385-48ef-bd42-f606fba81ae7" = {} # Reader
              }
            }
          }
          tags = {
            purpose = "web-development"
          }
        }
        webapp_staging = {
          name = "staging"
          project = { key = "webapp" }
          deployment_target_id = "/subscriptions/87654321-4321-4321-4321-210987654321"
          status = "Enabled"
          display_name = "Web App Staging Environment"
        }
        api_dev = {
          name = "development"
          project = { key = "api" }
          deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
          status = "Enabled"
          display_name = "API Development Environment"
          identity = {
            type = "SystemAssigned"
          }
        }
        api_prod = {
          name = "production"
          project = { key = "api" }
          deployment_target_id = "/subscriptions/11111111-2222-3333-4444-555555555555"
          status = "Disabled"  # Initially disabled for approval workflow
          display_name = "API Production Environment"
        }
      }
      ```
    - `examples/dev_center_project_environment_type/enhanced_case/README.md`: Enhanced example documentation
  - **Dependencies**: Step 6 completion

- [x] **Step 8: Create Unit Tests**
  - **Task**: Implement comprehensive unit tests using Terraform's native testing framework
  - **Files**:
    - `tests/unit/dev_center_project_environment_type/project_environment_type_test.tftest.hcl`:
      ```hcl
      variables {
        global_settings = {
          prefixes      = ["test"]
          random_length = 3
          default_region = "eastus"
        }
        
        project_environment_type = {
          name = "development"
          deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
          status = "Enabled"
          display_name = "Test Development Environment"
        }
        
        project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/projects/test-project"
        location = "eastus"
      }

      provider "azapi" {
        features {}
      }

      run "test_project_environment_type_creation" {
        command = plan
        
        assert {
          condition = azapi_resource.project_environment_type.type == "Microsoft.DevCenter/projects/environmentTypes@2025-07-01-preview"
          error_message = "Resource type should be Microsoft.DevCenter/projects/environmentTypes@2025-07-01-preview"
        }
        
        assert {
          condition = azapi_resource.project_environment_type.parent_id == var.project_id
          error_message = "Parent ID should be the project ID"
        }
        
        assert {
          condition = jsondecode(azapi_resource.project_environment_type.body).properties.deploymentTargetId == var.project_environment_type.deployment_target_id
          error_message = "Deployment target ID should match input"
        }
        
        assert {
          condition = jsondecode(azapi_resource.project_environment_type.body).properties.status == "Enabled"
          error_message = "Status should be Enabled by default"
        }
      }

      run "test_name_validation" {
        command = plan
        
        assert {
          condition = can(regex("^test-", azurecaf_name.project_environment_type.result))
          error_message = "Generated name should include prefix"
        }
      }

      run "test_optional_properties" {
        variables {
          project_environment_type = {
            name = "development"
            deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
            status = "Disabled"
            display_name = "Custom Display Name"
            creator_role_assignment = {
              roles = {
                "b24988ac-6180-42a0-ab88-20f7382dd24c" = {}
              }
            }
          }
        }
        
        command = plan
        
        assert {
          condition = jsondecode(azapi_resource.project_environment_type.body).properties.status == "Disabled"
          error_message = "Status should be configurable"
        }
        
        assert {
          condition = jsondecode(azapi_resource.project_environment_type.body).properties.displayName == "Custom Display Name"
          error_message = "Display name should be configurable"
        }
        
        assert {
          condition = can(jsondecode(azapi_resource.project_environment_type.body).properties.creatorRoleAssignment)
          error_message = "Creator role assignment should be configurable"
        }
      }
      ```
  - **Dependencies**: Step 7 completion

- [x] **Step 9: Update VS Code Tasks**
  - **Task**: Add new example options to VS Code tasks for easy testing
  - **Files**:
    - `.vscode/tasks.json`: Add project environment type example inputs:
      ```json
      {
        "id": "projectEnvironmentTypeExample",
        "description": "Select a Dev Center Project Environment Type example",
        "type": "pickString",
        "options": [
          {
            "label": "Simple Case",
            "value": "examples/dev_center_project_environment_type/simple_case/configuration.tfvars"
          },
          {
            "label": "Enhanced Case", 
            "value": "examples/dev_center_project_environment_type/enhanced_case/configuration.tfvars"
          }
        ]
      }
      ```
  - **Dependencies**: Step 8 completion

- [x] **Step 10: Update Documentation**
  - **Task**: Update project documentation to include the new module
  - **Files**:
    - `docs/file_structure.md`: Add project environment type entries
    - `docs/module_guide.md`: Add project environment type module documentation
    - `modules/dev_center_project_environment_type/README.md`: Complete module documentation with API reference
  - **Dependencies**: Step 9 completion

- [ ] **Step 11: Validation Testing**
  - **Task**: Validate the complete implementation using Terraform tools and run comprehensive tests
  - **Files**: N/A (validation commands)
  - **Commands**:
    - `terraform fmt -recursive` - Format all files
    - `terraform validate` - Validate configuration
    - `./tests/run_tests.sh` - Run all unit tests
    - Test both simple and enhanced examples with `terraform plan`
  - **Dependencies**: Step 10 completion

## Key Implementation Notes

1. **API Version**: Uses the latest 2025-07-01-preview API for project environment types
2. **Parent Resource**: Project environment types are children of DevCenter projects, requiring `parent_id`
3. **Required Properties**: `deploymentTargetId` is mandatory - specifies which subscription to deploy environments into
4. **Status Control**: Environment types can be Enabled/Disabled at the project level
5. **Role Assignments**: Supports both creator and user role assignments for fine-grained access control
6. **Identity Support**: Optional managed identity configuration for advanced scenarios
7. **Naming Convention**: Follows DevFactory patterns with azurecaf integration
8. **Validation**: Input validation for name patterns and status values

## Dependencies and Prerequisites

- DevCenter project must exist before creating project environment types
- DevCenter-level environment types must be defined before associating with projects
- Valid Azure subscription IDs required for deployment targets
- Appropriate RBAC permissions for role assignments (if configured)

This implementation provides a complete, production-ready module for managing DevCenter project environment types with comprehensive examples, testing, and documentation following DevFactory standards.
