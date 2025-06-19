# Dev Center Network Connection Enhanced Example

This example demonstrates how to create an enterprise-grade Dev Center Network Connection with Hybrid Azure AD Join configuration.

## Overview

This example creates:
- A resource group with production-grade tagging
- A virtual network with enterprise IP addressing
- A Dev Center Network Connection configured for Hybrid Azure AD Join
- Proper domain integration with organizational unit placement

## Configuration

The example uses the following configuration:
- Domain join type: Hybrid Azure AD Join (enterprise configuration)
- Virtual network with corporate IP addressing (172.16.0.0/16)
- Domain service account with appropriate permissions
- Organizational Unit placement for computer objects
- Comprehensive tagging strategy for governance

## Prerequisites

Before using this example, ensure:
1. Active Directory domain controllers are reachable from the subnet
2. Domain service account has permissions to join computers to the domain
3. Organizational unit exists and allows computer object creation
4. Network connectivity between Azure and on-premises AD

## Security Considerations

- Store domain passwords in Azure Key Vault in production
- Use dedicated service accounts with minimal required permissions
- Implement network security groups for proper traffic filtering
- Monitor domain join operations for security compliance

## Usage

1. Set the domain password as an environment variable:
```bash
export TF_VAR_domain_password="YourSecureDomainPassword"
```

2. Copy the `configuration.tfvars` file and modify the values as needed
3. Run Terraform commands:

```bash
terraform init
terraform plan -var-file=configuration.tfvars
terraform apply -var-file=configuration.tfvars
```

## Resources Created

- Azure Resource Group (with production tagging)
- Azure Virtual Network (enterprise IP addressing)
- Azure Subnet (dedicated for Dev Center)
- Azure Dev Center Network Connection (Hybrid Azure AD Join)

## Network Requirements

- Connectivity to domain controllers (typically ports 53, 88, 135, 389, 445, 464, 636, 3268, 3269)
- DNS resolution for the Active Directory domain
- Network security groups configured for domain traffic
- Proper routing between Azure and on-premises networks

## Domain Requirements

- Service account with domain join permissions
- Organizational unit with delegated permissions for computer object creation
- Domain controllers accessible from the Azure subnet
- Proper DNS configuration for domain resolution