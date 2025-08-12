# Dev Center Environment Type Module

This module creates an Azure Dev Center Environment Type, which defines the types of environments that can be created within a Dev Center.

## Usage

```hcl
module "dev_center_environment_type" {
  source = "./modules/dev_center_environment_type"

  global_settings = var.global_settings
  dev_center_id   = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/my-rg/providers/Microsoft.DevCenter/devcenters/my-devcenter"
  
  environment_type = {
    name         = "development"
    display_name = "Development Environment Type"
    tags = {
      Environment = "Development"
      Purpose     = "Dev Testing"
    }
  }
}
```

## Arguments

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| global_settings | Global settings object containing naming conventions and tags | `object` | n/a | yes |
| dev_center_id | The ID of the Dev Center that will contain the environment type | `string` | n/a | yes |
| environment_type | Configuration object for the environment type | `object` | n/a | yes |

### environment_type object

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the environment type | `string` | n/a | yes |
| display_name | The display name of the environment type | `string` | `null` | no |
| tags | A mapping of tags to assign to the environment type | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Dev Center Environment Type |
| name | The name of the Dev Center Environment Type |
| dev_center_id | The ID of the parent Dev Center |
| display_name | The display name of the Dev Center Environment Type |
| provisioning_state | The provisioning state of the Dev Center Environment Type |

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
