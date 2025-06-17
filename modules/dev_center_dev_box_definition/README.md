# Azure DevCenter DevBox Definition Module

This module creates an Azure DevCenter DevBox Definition using the AzAPI provider with direct Azure REST API access.

## Overview

The DevBox Definition module enables the creation and management of DevBox definitions within Azure DevCenter. It leverages the AzAPI provider to ensure compatibility with the latest Azure features and APIs, following DevFactory standardization patterns.

## Features

- Uses AzAPI provider v2.4.0 for latest Azure features
- Implements latest Azure DevCenter API (2025-04-01-preview)
- Supports multiple image reference formats
- Configurable SKU and storage options
- Hibernate support configuration
- Integrates with azurecaf naming conventions
- Manages resource tags (global + specific)
- Provides strong input validation

## Simple Usage

```hcl
module "dev_box_definition" {
  source = "./modules/dev_center_dev_box_definition"

  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  dev_center_id = "/subscriptions/.../devcenters/mydevcenter"
  dev_box_definition = {
    name               = "win11-dev"
    image_reference_id = "/subscriptions/.../galleries/mygallery/images/win11/versions/latest"
    sku_name          = "general_i_8c32gb256ssd_v2"
  }
}
```

## Advanced Usage

```hcl
module "dev_box_definition" {
  source = "./modules/dev_center_dev_box_definition"

  global_settings = {
    prefixes      = ["prod"]
    random_length = 5
    passthrough   = false
    use_slug      = true
  }

  location      = "eastus"
  dev_center_id = "/subscriptions/.../devcenters/mydevcenter"

  dev_box_definition = {
    name = "ai-development-box"
    
    # Built-in Azure DevCenter image (recommended)
    image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"
    
    # Or custom gallery image
    # image_reference = {
    #   id = "galleries/mygallery/images/ai-dev-image"
    # }
      sku_name        = "general_i_32c128gb1024ssd_v2"
    
    hibernate_support = {
      enabled = true
    }
    
    tags = {
      purpose     = "ai-development"
      cost_center = "engineering"
      environment = "production"
    }
  }

  tags = {
    managed_by = "terraform"
    module     = "dev_center_dev_box_definition"
  }
}
```

For more examples, see the [DevBox Definition examples](../../../examples/dev_center_dev_box_definition/).

## Resources

- Azure DevCenter DevBox Definition (`Microsoft.DevCenter/devcenters/devboxdefinitions`)

## Azure API Reference

This module implements the [Microsoft.DevCenter/devcenters/devboxdefinitions](https://learn.microsoft.com/en-us/azure/templates/microsoft.devcenter/2025-04-01-preview/devcenters/devboxdefinitions) resource type using API version 2025-04-01-preview.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.9.0 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | ~> 2.4.0 |
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~> 1.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.4.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 1.2.28 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.dev_box_definition](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.dev_box_definition](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_box_definition"></a> [dev\_box\_definition](#input\_dev\_box\_definition) | Configuration object for the DevBox Definition | <pre>object({<br/>    name = string<br/>    <br/>    # Image reference - supports both direct ID and object form<br/>    image_reference_id = optional(string)<br/>    image_reference = optional(object({<br/>      id = string<br/>    }))<br/>    <br/>    # SKU configuration - storage is defined within the SKU name itself<br/>    sku_name = string<br/>    <br/>    # Hibernate support<br/>    hibernate_support = optional(object({<br/>      enabled = optional(bool, false)<br/>    }))<br/>    <br/>    # Tags<br/>    tags = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_dev_center_id"></a> [dev\_center\_id](#input\_dev\_center\_id) | The ID of the Dev Center where the DevBox Definition will be created | `string` | n/a | yes |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global settings object for naming conventions and standard parameters | <pre>object({<br/>    prefixes      = list(string)<br/>    random_length = number<br/>    passthrough   = bool<br/>    use_slug      = bool<br/>    tags          = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to the DevBox Definition | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dev_center_id"></a> [dev\_center\_id](#output\_dev\_center\_id) | The ID of the Dev Center |
| <a name="output_hibernate_support"></a> [hibernate\_support](#output\_hibernate\_support) | The hibernate support status |
| <a name="output_id"></a> [id](#output\_id) | The ID of the DevBox Definition |
| <a name="output_image_reference"></a> [image\_reference](#output\_image\_reference) | The image reference configuration |
| <a name="output_name"></a> [name](#output\_name) | The name of the DevBox Definition |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the DevBox Definition |
| <a name="output_sku"></a> [sku](#output\_sku) | The SKU configuration |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags assigned to the DevBox Definition |
<!-- END_TF_DOCS -->

## Validation Rules

The module includes comprehensive validation for:

- **DevBox Definition Name**: Must be 63 characters or less and follow Azure naming conventions
- **Image Reference**: Either `image_reference_id` or `image_reference` object must be provided
- **Dev Center ID**: Must be a valid Azure resource ID format

## Automatic Subscription ID Resolution

The module automatically resolves subscription IDs in image references. You can use placeholder values like `subscription-id` in your configuration, and the module will automatically replace them with the current subscription ID:

```hcl
image_reference_id = "/subscriptions/subscription-id/resourceGroups/rg-shared-images/providers/Microsoft.Compute/galleries/gallery1/images/win11-dev/versions/latest"
```

This will automatically become:

```hcl
"/subscriptions/33e81e94-c18c-4d5a-a613-897c92b35411/resourceGroups/rg-shared-images/providers/Microsoft.Compute/galleries/gallery1/images/win11-dev/versions/latest"
```

This feature makes configurations portable across different Azure subscriptions without manual modification.

## Security Considerations

- Use managed identities for secure authentication
- Apply least privilege access policies
- Use Azure Private Endpoints when available
- Regularly update base images for security patches
- Monitor DevBox usage and costs
