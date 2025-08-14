# Azure Dev Center Project Environment Type Module

This module creates project environment type associations within an Azure Dev Center project. Project environment types link specific environment types to projects, making them available for use within the project.

## Usage

### Simple Usage

```hcl
module "dev_center_project_environment_type" {
  source = "./modules/dev_center_project_environment_type"

  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  project_environment_type = {
    name = "development"
    tags = {
      environment = "development"
      purpose     = "team-development"
    }
  }

  dev_center_project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-example/providers/Microsoft.DevCenter/projects/project-example"
}
```

### Advanced Usage with User Role Assignments

```hcl
module "dev_center_project_environment_type" {
  source = "./modules/dev_center_project_environment_type"

  global_settings = {
    prefixes      = ["prod"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  project_environment_type = {
    name   = "production"
    status = "Enabled"
    user_role_assignments = {
      "user1@contoso.com" = {
        roles = ["DevCenter Project Admin", "Deployment Environments User"]
      }
      "group1@contoso.com" = {
        roles = ["Deployment Environments User"]
      }
    }
    tags = {
      environment = "production"
      tier        = "critical"
    }
  }

  dev_center_project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-example/providers/Microsoft.DevCenter/projects/project-example"
}
```

For more examples including all possible configurations, see the [Dev Center Project Environment Type examples](../../../examples/dev_center_project_environment_type/).

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.4.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~> 1.2.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | ~> 2.4.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | ~> 1.2.29 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.dev_center_project_environment_type](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.project_environment_type](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_deployment_target_id"></a> [deployment\_target\_id](#input\_deployment\_target\_id) | The ID of the deployment target for this project environment type | `string` | n/a | yes |
| <a name="input_dev_center_project_id"></a> [dev\_center\_project\_id](#input\_dev\_center\_project\_id) | The ID of the Dev Center Project that will contain the environment type | `string` | n/a | yes |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global settings object | <pre>object({<br/>    prefixes      = optional(list(string))<br/>    random_length = optional(number)<br/>    passthrough   = optional(bool)<br/>    use_slug      = optional(bool)<br/>    tags          = optional(map(string))<br/>  })</pre> | n/a | yes |
| <a name="input_project_environment_type"></a> [project\_environment\_type](#input\_project\_environment\_type) | Configuration object for the Dev Center Project Environment Type | <pre>object({<br/>    name   = string<br/>    status = optional(string, "Enabled")<br/>    user_role_assignments = optional(map(object({<br/>      roles = list(string)<br/>    })))<br/>    tags = optional(map(string))<br/>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_deployment_target_id"></a> [deployment\_target\_id](#output\_deployment\_target\_id) | The deployment target ID for the project environment type |
| <a name="output_dev_center_project_id"></a> [dev\_center\_project\_id](#output\_dev\_center\_project\_id) | The ID of the parent Dev Center Project |
| <a name="output_id"></a> [id](#output\_id) | The ID of the Dev Center Project Environment Type |
| <a name="output_name"></a> [name](#output\_name) | The name of the Dev Center Project Environment Type |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the Dev Center Project Environment Type |
| <a name="output_status"></a> [status](#output\_status) | The status of the Dev Center Project Environment Type |
| <a name="output_user_role_assignments"></a> [user\_role\_assignments](#output\_user\_role\_assignments) | The user role assignments for the project environment type |
<!-- END_TF_DOCS -->

## Features

- Associates environment types with Dev Center projects
- Automatically uses current subscription as deployment target
- Configurable status (Enabled/Disabled)
- User role assignments for granular access control
- Comprehensive validation for inputs
- Support for resource tags
- Compatible with Azure DevCenter 2025-04-01-preview API

## Validation Rules

- Project environment type name must be 3-128 characters, alphanumeric with hyphens, underscores, and periods
- Status must be either "Enabled" or "Disabled"
- Dev Center Project ID must be a valid resource ID format
- Deployment target is automatically set to current subscription

## Security Considerations

- Use least privilege access for role assignments
- Consider using Azure AD groups instead of individual users for role assignments
- Environment resources will be deployed to the current subscription
- Review and audit user role assignments regularly
