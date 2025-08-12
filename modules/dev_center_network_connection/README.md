# Dev Center Network Connection Module

This module manages an Azure Dev Center Network Connection using the `azapi_resource` resource.

## Overview

A Dev Center Network Connection enables Azure Dev Center to connect Dev Boxes to your organization's network, providing access to resources and services in your virtual network.

## Features

- Support for Azure AD Join and Hybrid Azure AD Join domain configurations
- Integration with existing virtual networks and subnets
- Configurable domain settings for hybrid scenarios
- Support for organizational unit specification
- Standard Azure resource tagging

## Example Usage

### Simple Azure AD Join Configuration

```hcl
module "dev_center_network_connection" {
  source = "../../modules/dev_center_network_connection"

  global_settings = {
    prefixes      = ["myorg"]
    random_length = 5
    passthrough   = false
    use_slug      = true
  }

  resource_group_name = "rg-dev-center"
  location           = "West Europe"

  dev_center_network_connection = {
    name             = "example-network-connection"
    domain_join_type = "AzureADJoin"
    subnet_id        = "/subscriptions/.../subnets/dev-subnet"
    tags = {
      Environment = "Development"
      Purpose     = "DevCenter"
    }
  }
}
```

### Hybrid Azure AD Join Configuration

```hcl
module "dev_center_network_connection" {
  source = "../../modules/dev_center_network_connection"

  global_settings = {
    prefixes      = ["myorg"]
    random_length = 5
    passthrough   = false
    use_slug      = true
  }

  resource_group_name = "rg-dev-center"
  location           = "West Europe"

  dev_center_network_connection = {
    name              = "hybrid-network-connection"
    domain_join_type  = "HybridAzureADJoin"
    subnet_id         = "/subscriptions/.../subnets/dev-subnet"
    domain_name       = "contoso.local"
    domain_username   = "domain-admin"
    domain_password   = "SecurePassword123!"
    organization_unit = "OU=DevBoxes,DC=contoso,DC=local"
    tags = {
      Environment = "Production"
      Purpose     = "DevCenter"
    }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.9.0 |
| azurecaf | ~> 1.2.29 |
| azapi | ~> 2.4.0 |

## Providers

| Name | Version |
|------|---------|
| azurecaf | ~> 1.2.29 |
| azapi | ~> 2.4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| global_settings | Global settings object | `object({...})` | n/a | yes |
| resource_group_name | The name of the resource group in which to create the Dev Center Network Connection | `string` | n/a | yes |
| location | The location/region where the Dev Center Network Connection is created | `string` | n/a | yes |
| dev_center_network_connection | Configuration object for the Dev Center Network Connection | `object({...})` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Dev Center Network Connection |
| name | The name of the Dev Center Network Connection |
| location | The location of the Dev Center Network Connection |
| resource_group_name | The resource group name of the Dev Center Network Connection |
| domain_join_type | The domain join type of the Dev Center Network Connection |
| subnet_id | The subnet ID of the Dev Center Network Connection |
| provisioning_state | The provisioning state of the Dev Center Network Connection |
| health_check_status | The health check status of the Dev Center Network Connection |

## Resources

| Name | Type |
|------|------|
| azurecaf_name.dev_center_network_connection | resource |
| azapi_resource.this | resource |
| azapi_client_config.current | data source |

## Notes

- Network connections require an existing virtual network and subnet
- For hybrid domain join scenarios, ensure domain credentials have appropriate permissions
- The subnet must have network connectivity to domain controllers for hybrid scenarios
- Consider network security groups and firewall rules for proper connectivity