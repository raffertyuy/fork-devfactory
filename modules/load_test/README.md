# Azure Load Test Module

This module creates an Azure Load Test resource for high-scale load generation and testing applications.

## Features

- Azure Load Testing service provisioning
- Managed identity support (System-assigned, User-assigned, or both)
- Customer-managed key encryption
- Consistent naming using azurecaf
- Comprehensive tagging support
- Strong input validation

## Usage

### Basic Example

```hcl
module "load_test" {
  source = "./modules/load_test"

  load_test = {
    name        = "my-load-test"
    description = "Load testing service for my application"
    tags = {
      environment = "development"
      purpose     = "load-testing"
    }
  }

  location            = "eastus"
  resource_group_name = "my-resource-group"
  global_settings = {
    prefixes = ["company"]
    suffixes = ["001"]
    tags = {
      project = "my-project"
    }
  }
}
```

### Advanced Example with Identity and Encryption

```hcl
module "load_test" {
  source = "./modules/load_test"

  load_test = {
    name        = "secure-load-test"
    description = "Production load testing with encryption"
    
    identity = {
      type = "SystemAssigned"
    }
    
    encryption = {
      identity = {
        type = "SystemAssigned"
      }
      key_url = "https://my-keyvault.vault.azure.net/keys/loadtest-key/version"
    }
    
    tags = {
      environment = "production"
      encryption  = "enabled"
    }
  }

  location            = "eastus"
  resource_group_name = "production-rg"
  global_settings = {
    prefixes = ["company"]
    suffixes = ["prod"]
  }
}
```

### User-Assigned Identity Example

```hcl
module "load_test" {
  source = "./modules/load_test"

  load_test = {
    name = "user-identity-load-test"
    
    identity = {
      type = "UserAssigned"
      identity_ids = [
        "/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity"
      ]
    }
    
    encryption = {
      identity = {
        type        = "UserAssigned"
        resource_id = "/subscriptions/sub-id/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/my-identity"
      }
      key_url = "https://my-keyvault.vault.azure.net/keys/loadtest-key"
    }
  }

  location            = "eastus"
  resource_group_name = "my-rg"
  global_settings     = var.global_settings
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
| [azapi_resource.this](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/azapi_resource) | resource |
| [azurecaf_name.this](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/azurecaf_name) | resource |
| [azapi_client_config.current](https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/azapi_client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| load_test | Configuration object for the Azure Load Test resource | `object({...})` | n/a | yes |
| location | The Azure region where the load test resource will be created | `string` | `"eastus"` | no |
| resource_group_name | The name of the resource group where the load test will be created | `string` | n/a | yes |
| global_settings | Global settings for resource naming and tagging | `object({...})` | `{...}` | no |

### load_test Object Structure

```hcl
load_test = {
  name        = string                    # Required: 2-64 chars, alphanumeric, underscore, hyphen
  description = optional(string)          # Optional: Max 512 characters
  
  identity = optional(object({            # Optional: Managed identity configuration
    type         = string                 # Required: "None", "SystemAssigned", "UserAssigned", "SystemAssigned,UserAssigned"
    identity_ids = optional(list(string)) # Optional: List of user-assigned identity resource IDs
  }))
  
  encryption = optional(object({          # Optional: Customer-managed key encryption
    identity = optional(object({
      type        = string                # Required: "SystemAssigned" or "UserAssigned"
      resource_id = optional(string)      # Optional: User-assigned identity resource ID for encryption
    }))
    key_url = optional(string)            # Optional: Key Vault key URL (versioned or non-versioned)
  }))
  
  tags = optional(map(string), {})        # Optional: Resource-specific tags
}
```

## Outputs

| Name | Description |
|------|-------------|
| load_test_id | The resource ID of the Azure Load Test |
| load_test_name | The name of the Azure Load Test |
| data_plane_uri | The data plane URI for the Azure Load Test |
| provisioning_state | The provisioning state of the Azure Load Test |
| location | The Azure region where the load test is deployed |
| resource_group_name | The name of the resource group containing the load test |
| tags | The tags assigned to the load test resource |

## Validation Rules

- **Name**: Must be 2-64 characters, start and end with alphanumeric, contain only alphanumeric, underscores, and hyphens
- **Description**: Maximum 512 characters
- **Identity Type**: Must be one of: None, SystemAssigned, UserAssigned, SystemAssigned,UserAssigned
- **Encryption Identity Type**: Must be either SystemAssigned or UserAssigned

## API Version

This module uses the `Microsoft.LoadTestService/loadTests@2024-12-01-preview` API version, which is the latest available version supporting all current features.

## Security Considerations

- Use managed identities instead of service principals when possible
- Enable customer-managed key encryption for sensitive workloads
- Apply least-privilege access principles
- Use Azure Key Vault for storing encryption keys
- Regular review and rotation of encryption keys

## Known Limitations

- Load test names have a maximum length of 64 characters
- Customer-managed encryption requires appropriate Key Vault permissions
- User-assigned identities must exist before referencing them
