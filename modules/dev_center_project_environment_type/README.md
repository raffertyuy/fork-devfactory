# Dev Center Project Environment Type Module

This module creates Azure DevCenter project environment types using the AzAPI provider v2.4.0.

## Overview

Dev Center Project Environment Types establish the relationship between a DevCenter project and environment types that can be used within that project. This is different from the DevCenter-level environment types which define the global environment types available across the DevCenter. Project environment types configure how those global environment types are used within specific projects, including deployment target subscriptions, role assignments, and status configuration.

## Usage

### Simple Example

```hcl
module "project_environment_type" {
  source = "./modules/dev_center_project_environment_type"

  global_settings = {
    prefixes      = ["demo"]
    random_length = 3
    tags = {
      environment = "development"
      workload    = "devcenter"
    }
  }

  project_environment_type = {
    name = "development"
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
    status = "Enabled"
  }

  project_id = module.dev_center_project.id
  location   = "eastus"
}
```

### Enhanced Example with Role Assignments

```hcl
module "project_environment_type" {
  source = "./modules/dev_center_project_environment_type"

  global_settings = {
    prefixes      = ["corp"]
    random_length = 3
    tags = {
      environment = "production"
      workload    = "devcenter"
    }
  }

  project_environment_type = {
    name = "development"
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
    status = "Enabled"
    display_name = "Development Environment"
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
    identity = {
      type = "SystemAssigned"
    }
    tags = {
      purpose = "development"
    }
  }

  project_id = module.dev_center_project.id
  location   = "eastus"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| azapi | ~> 2.4.0 |
| azurecaf | ~> 1.2.29 |

## Providers

| Name | Version |
|------|---------|
| azapi | ~> 2.4.0 |
| azurecaf | ~> 1.2.29 |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.this](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.project_environment_type](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| global_settings | Global settings for resource naming and tagging | `object({...})` | `{}` | no |
| project_environment_type | Configuration for the Dev Center project environment type | `object({...})` | n/a | yes |
| project_id | The resource ID of the DevCenter project | `string` | n/a | yes |
| location | The Azure region where the resource will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The resource ID of the project environment type |
| name | The name of the project environment type |
| deployment_target_id | The deployment target subscription ID |
| status | The status of the project environment type (Enabled/Disabled) |
| display_name | The display name of the project environment type |
| provisioning_state | The provisioning state of the project environment type |
| creator_role_assignment | The creator role assignments |
| user_role_assignments | The user role assignments |
| location | The location of the project environment type |
| tags | The tags assigned to the project environment type |

## API Reference

This module uses the `Microsoft.DevCenter/projects/environmentTypes@2025-04-01-preview` API version for managing Azure DevCenter project environment types.

### Key Properties

- **deploymentTargetId**: (Required) The subscription ID where environments will be deployed
- **status**: (Optional) "Enabled" or "Disabled" - controls whether the environment type is available for use
- **displayName**: (Optional) A user-friendly display name for the environment type
- **creatorRoleAssignment**: (Optional) Role assignments for environment creators
- **userRoleAssignments**: (Optional) Role assignments for environment users
- **identity**: (Optional) Managed identity configuration

### Role Assignment Structure

Role assignments follow this structure:

```hcl
creator_role_assignment = {
  roles = {
    "<role-definition-id>" = {}
  }
}

user_role_assignments = {
  "<user-object-id>" = {
    roles = {
      "<role-definition-id>" = {}
    }
  }
}
```

Common Azure role definition IDs:

- Contributor: `b24988ac-6180-42a0-ab88-20f7382dd24c`
- Reader: `acdd72a7-3385-48ef-bd42-f606fba81ae7`
- Owner: `8e3af657-a8ff-443c-a75c-2fe8c4bcb635`

## Dependencies

This module requires:

- A DevCenter project must exist before creating project environment types
- DevCenter-level environment types must be defined before associating with projects
- Valid Azure subscription IDs for deployment targets
- Appropriate RBAC permissions for role assignments (if configured)
