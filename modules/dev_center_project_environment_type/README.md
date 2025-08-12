# Dev Center Project Environment Type Module

This module creates an Azure Dev Center Project Environment Type, which links environment types to specific projects within a Dev Center, enabling project-specific environment management.

## Usage

```hcl
module "dev_center_project_environment_type" {
  source = "./modules/dev_center_project_environment_type"

  global_settings       = var.global_settings
  dev_center_project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.DevCenter/projects/my-project"
  location              = "eastus"
  
  project_environment_type = {
    name                  = "development"
    environment_type_name = "Dev"
    deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg"
    creator_role_assignment = {
      roles = ["Contributor"]
    }
    user_role_assignments = [
      {
        roles   = ["Reader", "Contributor"]
        user_id = "user1@example.com"
      }
    ]
    tags = {
      Environment = "Development"
      Purpose     = "Dev Environment"
    }
  }
}
```

## Arguments

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| global_settings | Global settings object containing naming conventions and tags | `object` | n/a | yes |
| dev_center_project_id | The ID of the Dev Center Project that will contain the environment type | `string` | n/a | yes |
| location | The location/region where the Dev Center Project Environment Type is created | `string` | n/a | yes |
| project_environment_type | Configuration object for the project environment type | `object` | n/a | yes |

### project_environment_type object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the project environment type | `string` | n/a | yes |
| environment_type_name | The name of the environment type to link to this project | `string` | n/a | yes |
| deployment_target_id | The ID of the deployment target (typically a resource group or subscription) | `string` | n/a | yes |
| creator_role_assignment | Role assignment configuration for environment creators | `object` | `null` | no |
| user_role_assignments | List of user role assignments for this environment type | `list(object)` | `null` | no |
| tags | A mapping of tags to assign to the project environment type | `map(string)` | `{}` | no |

### creator_role_assignment object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| roles | List of roles to assign to environment creators | `list(string)` | n/a | yes |

### user_role_assignments object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| roles | List of roles to assign to the user | `list(string)` | n/a | yes |
| user_id | The user ID or email address | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Dev Center Project Environment Type |
| name | The name of the Dev Center Project Environment Type |
| dev_center_project_id | The ID of the parent Dev Center Project |
| environment_type_name | The name of the environment type linked to this project |
| deployment_target_id | The deployment target ID for this project environment type |
| location | The location of the Dev Center Project Environment Type |
| provisioning_state | The provisioning state of the Dev Center Project Environment Type |

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