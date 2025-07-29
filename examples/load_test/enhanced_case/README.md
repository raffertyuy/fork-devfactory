# Azure Load Test - Enhanced Case Example

This example demonstrates how to create an advanced Azure Load Test resource with identity and encryption features using the DevFactory load test module.

## Overview

This configuration creates:
- A resource group for hosting the load test  
- An enhanced Azure Load Test service with managed identity and customer-managed encryption

## Configuration

The example includes:
- **Enhanced Load Test**: Advanced load testing service with identity and encryption
- **System-Assigned Identity**: Automatic identity management by Azure
- **Customer-Managed Encryption**: Key Vault integration for encryption keys
- **Resource Group**: Dedicated resource group for the load test resources
- **Global Settings**: Production naming conventions and tagging

## Usage

⚠️ **Important**: Before running this example, ensure you have:
1. A Key Vault with appropriate access policies
2. A key named `loadtest-key` in your Key Vault
3. Proper permissions to create managed identities

### Steps

1. Navigate to this directory:
   ```bash
   cd examples/load_test/enhanced_case
   ```

2. Update the `key_url` in `configuration.tfvars` to point to your actual Key Vault and key

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Plan the deployment:
   ```bash
   terraform plan -var-file="configuration.tfvars"
   ```

5. Apply the configuration:
   ```bash
   terraform apply -var-file="configuration.tfvars"
   ```

## Resources Created

- **Resource Group**: `devfactory-loadtest-resources-prod-001`
- **Load Test**: `devfactory-enhanced-load-test-prod-001`
- **System-Assigned Identity**: Automatically created and assigned

## Configuration Details

### Load Test Configuration
- **Name**: `enhanced-load-test`
- **Description**: Enhanced load testing service with identity and encryption
- **Identity**: System-assigned managed identity
- **Encryption**: Customer-managed key encryption using Key Vault
- **Tags**: Includes environment, purpose, and encryption status

### Security Features
- **Managed Identity**: System-assigned identity for secure Azure resource access
- **Encryption**: Customer-managed key encryption for data at rest
- **Key Vault Integration**: Secure key management through Azure Key Vault

### Resource Group
- **Name**: `loadtest-resources`
- **Location**: `eastus`

## Key Vault Requirements

This example requires a Key Vault with:
```hcl
# Example Key Vault configuration (not included in this example)
resource "azurerm_key_vault" "example" {
  name                = "my-keyvault"
  location            = "eastus"
  resource_group_name = "my-resource-group"
  sku_name           = "standard"
  tenant_id          = data.azurerm_client_config.current.tenant_id

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = azurerm_user_assigned_identity.example.principal_id

    key_permissions = [
      "Get",
      "WrapKey",
      "UnwrapKey"
    ]
  }
}

resource "azurerm_key_vault_key" "example" {
  name         = "loadtest-key"
  key_vault_id = azurerm_key_vault.example.id
  key_type     = "RSA"
  key_size     = 2048
}
```

## Cleanup

To remove all resources:
```bash
terraform destroy -var-file="configuration.tfvars"
```

## Next Steps

- Configure load test execution scripts
- Set up monitoring and alerting
- Integrate with CI/CD pipelines
- Review the [simple case example](../simple_case/) for basic configuration
