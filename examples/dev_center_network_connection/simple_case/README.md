# Dev Center Network Connection Simple Example

This example demonstrates how to create a basic Dev Center Network Connection with Azure AD Join.

## Overview

This example creates:
- A resource group
- A virtual network with a subnet
- A Dev Center Network Connection configured for Azure AD Join

## Configuration

The example uses the following configuration:
- Domain join type: Azure AD Join (simplest configuration)
- Virtual network with a dedicated subnet for Dev Center
- Basic tagging strategy

## Usage

1. Copy the `configuration.tfvars` file and modify the values as needed
2. Run Terraform commands:

```bash
terraform init
terraform plan -var-file=configuration.tfvars
terraform apply -var-file=configuration.tfvars
```

## Resources Created

- Azure Resource Group
- Azure Virtual Network  
- Azure Subnet
- Azure Dev Center Network Connection (Azure AD Join)

## Network Requirements

- The subnet must be dedicated to Dev Center usage
- Ensure network security groups allow required traffic
- Consider regional placement for optimal performance