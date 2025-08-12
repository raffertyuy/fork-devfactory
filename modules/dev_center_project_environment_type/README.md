# Dev Center Project Environment Type Module

This module creates an Azure Dev Center Project Environment Type, which links environment types to specific projects within a Dev Center, enabling those projects to create environments of the specified types.

## Usage

```hcl
module "dev_center_project_environment_type" {
  source = "./modules/dev_center_project_environment_type"

  global_settings         = var.global_settings
  dev_center_project_id   = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.DevCenter/projects/my-project"
  environment_type_id     = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.DevCenter/devcenters/my-devcenter/environmentTypes/development"
  deployment_target_id    = "/subscriptions/12345678-1234-1234-1234-123456789012"
  location               = "eastus"
  
  project_environment_type = {
    status = "Enabled"
    creator_role_assignment = {
      roles = ["Contributor", "DevCenter Dev Box User"]
    }
    tags = {
      Environment = "Development"
      Purpose     = "Project Environment Type"
    }
  }
}
```

## Arguments

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| global_settings | Global settings object containing naming conventions and tags | `object` | `{}` | no |
| dev_center_project_id | The ID of the Dev Center Project that will contain the environment type | `string` | n/a | yes |
| environment_type_id | The ID of the Dev Center Environment Type to link to this project | `string` | n/a | yes |
| deployment_target_id | The ID of the deployment target (subscription or resource group) for environments | `string` | n/a | yes |
| location | The Azure region where the project environment type will be created | `string` | `"eastus"` | no |
| project_environment_type | Configuration object for the project environment type | `object` | n/a | yes |

### global_settings object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefixes | List of prefixes to apply to resource names | `list(string)` | `[]` | no |
| random_length | Length of random suffix for resource names | `number` | `0` | no |
| passthrough | Whether to pass through the name without modification | `bool` | `false` | no |
| use_slug | Whether to use slug in the name | `bool` | `true` | no |
| tags | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |

### project_environment_type object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| status | The status of the project environment type (Enabled/Disabled) | `string` | `"Enabled"` | no |
| creator_role_assignment | Role assignment configuration for environment creators | `object` | `null` | no |
| tags | A mapping of tags to assign to the project environment type | `map(string)` | `{}` | no |

### creator_role_assignment object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| roles | List of role names to assign to environment creators | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the DevCenter project environment type |
| name | The name of the DevCenter project environment type |
| resource_id | The full resource ID of the DevCenter project environment type |
| properties | The properties of the DevCenter project environment type |
| dev_center_project_id | The ID of the parent Dev Center Project |
| environment_type_id | The ID of the linked environment type |
| deployment_target_id | The deployment target ID for environments of this type |
| display_name | The display name of the project environment type |
| status | The status of the project environment type |
| provisioning_state | The provisioning state of the project environment type |
| tags | The tags applied to the DevCenter project environment type |

## Example

```hcl
# Link development environment type to a project
module "project_env_type_dev" {
  source = "./modules/dev_center_project_environment_type"

  global_settings = {
    prefixes      = ["myorg", "dev"]
    random_length = 3
    use_slug      = true
    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
    }
  }

  dev_center_project_id = module.dev_center_projects["project1"].id
  environment_type_id   = module.dev_center_environment_types["development"].id
  deployment_target_id  = "/subscriptions/${var.subscription_id}"
  location             = "eastus"

  project_environment_type = {
    status = "Enabled"
    creator_role_assignment = {
      roles = ["Contributor"]
    }
    tags = {
      ProjectType = "Development"
      Team        = "Engineering"
    }
  }
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
| [azapi_resource.dev_center_project_environment_type](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.project_environment_type](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |