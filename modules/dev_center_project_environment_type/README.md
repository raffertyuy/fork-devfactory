# Dev Center Project Environment Type Module

This module creates an Azure Dev Center Project Environment Type, which links environment types to specific projects within a Dev Center.

## Overview

Project Environment Types define which environment types are available within a specific Dev Center project and configure the deployment targets and role assignments for those environments.

## Resources

- Azure DevCenter Project Environment Type (`Microsoft.DevCenter/projects/environmentTypes`)

## Azure API Reference

This module implements the [Microsoft.DevCenter/projects/environmentTypes](https://learn.microsoft.com/en-us/azure/templates/microsoft.devcenter/2025-04-01-preview/projects/environmenttypes) resource type using API version 2025-04-01-preview.

## Usage

### Simple Usage

```hcl
module "dev_center_project_environment_type" {
  source = "./modules/dev_center_project_environment_type"

  global_settings = var.global_settings
  dev_center_project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.DevCenter/projects/my-project"
  deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg"
  
  project_environment_type = {
    name = "development"
    tags = {
      Environment = "Development"
      Purpose     = "Dev Testing"
    }
  }
}
```

### Advanced Usage with Role Assignments

```hcl
module "dev_center_project_environment_type" {
  source = "./modules/dev_center_project_environment_type"

  global_settings = var.global_settings
  dev_center_project_id = module.dev_center_project.id
  deployment_target_id = module.resource_group.id
  
  project_environment_type = {
    name   = "production"
    status = "Enabled"
    
    creator_role_assignment = {
      roles = [
        "b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor
      ]
    }
    
    user_role_assignments = {
      "development-team" = {
        roles = [
          "acdd72a7-3385-48ef-bd42-f606fba81ae7" # Reader
        ]
      }
    }
    
    tags = {
      Environment = "Production"
      Purpose     = "Production Workloads"
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.4.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~> 1.2.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.4.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 1.2.29 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.project_environment_type](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.project_environment_type](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global settings object | <pre>object({<br>    prefixes      = optional(list(string))<br>    random_length = optional(number)<br>    passthrough   = optional(bool)<br>    use_slug      = optional(bool)<br>    tags          = optional(map(string), {})<br>  })</pre> | n/a | yes |
| <a name="input_dev_center_project_id"></a> [dev\_center\_project\_id](#input\_dev\_center\_project\_id) | The ID of the Dev Center Project in which to create the environment type | `string` | n/a | yes |
| <a name="input_deployment_target_id"></a> [deployment\_target\_id](#input\_deployment\_target\_id) | The ID of the deployment target for the environment type | `string` | n/a | yes |
| <a name="input_project_environment_type"></a> [project\_environment\_type](#input\_project\_environment\_type) | Configuration object for the Project Environment Type | <pre>object({<br>    name = string<br>    tags = optional(map(string), {})<br>    status = optional(string, "Enabled")<br>    creator_role_assignment = optional(object({<br>      roles = list(string)<br>    }))<br>    user_role_assignments = optional(map(object({<br>      roles = list(string)<br>    })), {})<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the Dev Center Project Environment Type |
| <a name="output_name"></a> [name](#output\_name) | The name of the Dev Center Project Environment Type |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The ID of the parent Dev Center Project |
| <a name="output_deployment_target_id"></a> [deployment\_target\_id](#output\_deployment\_target\_id) | The ID of the deployment target |
| <a name="output_status"></a> [status](#output\_status) | The status of the Project Environment Type |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Project Environment Type |

## Validation Rules

- Environment type name must start and end with an alphanumeric character
- Environment type name can contain letters, numbers, underscores, and hyphens
- Status must be either "Enabled" or "Disabled"

## Security Considerations

- Use role assignments to control access to environment types
- Ensure deployment targets have appropriate permissions
- Review and audit role assignments regularly
- Follow principle of least privilege for role assignments