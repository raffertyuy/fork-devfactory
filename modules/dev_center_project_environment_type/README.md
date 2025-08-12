# Dev Center Project Environment Type Module

This module creates an Azure Dev Center Project Environment Type, which links environment types to projects within a Dev Center and enables projects to use specific environment types for environment creation.

## Usage

```hcl
module "dev_center_project_environment_type" {
  source = "./modules/dev_center_project_environment_type"

  global_settings       = var.global_settings
  dev_center_project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.DevCenter/projects/my-project"
  location              = "eastus"
  deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012"
  
  project_environment_type = {
    name         = "development"
    display_name = "Development Environment Type"
    status       = "Enabled"
    tags = {
      Environment = "Development"
      Purpose     = "Dev Testing"
    }
    
    creator_role_assignment = {
      roles = {
        owner = {
          role_definition_id = "/subscriptions/12345678-1234-1234-1234-123456789012/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
        }
      }
    }
  }
}
```

## Arguments

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| global_settings | Global settings object containing naming conventions and tags | `object` | n/a | yes |
| dev_center_project_id | The ID of the Dev Center Project that will contain the environment type | `string` | n/a | yes |
| location | The location/region where the Project Environment Type is created | `string` | n/a | yes |
| deployment_target_id | The ID of the deployment target (subscription) for the environment type | `string` | n/a | yes |
| project_environment_type | Configuration object for the project environment type | `object` | n/a | yes |

### project_environment_type object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the project environment type | `string` | n/a | yes |
| display_name | The display name of the project environment type | `string` | `null` | no |
| status | The status of the project environment type | `string` | `"Enabled"` | no |
| tags | A mapping of tags to assign to the project environment type | `map(string)` | `{}` | no |
| creator_role_assignment | Creator role assignment configuration | `object` | `null` | no |
| user_role_assignments | User role assignments configuration | `map(object)` | `null` | no |

### creator_role_assignment object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| roles | Map of role assignments for creators | `map(object)` | n/a | yes |

### user_role_assignments object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| roles | Map of role assignments for users | `map(object)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Dev Center Project Environment Type |
| name | The name of the Dev Center Project Environment Type |
| location | The location of the Dev Center Project Environment Type |
| dev_center_project_id | The ID of the parent Dev Center Project |
| deployment_target_id | The ID of the deployment target for this environment type |
| status | The status of the Dev Center Project Environment Type |
| display_name | The display name of the Dev Center Project Environment Type |
| provisioning_state | The provisioning state of the Dev Center Project Environment Type |
| tags | The tags assigned to the Dev Center Project Environment Type |

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