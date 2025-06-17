# DevBox Definition Simple Example

This example demonstrates how to create a basic Azure DevCenter DevBox Definition using the DevFactory Terraform modules.

## Overview

This example creates:
- 1 Resource Group
- 1 Dev Center with system-assigned identity
- 1 DevBox Definition with Windows 11 development image

## Configuration Details

### DevBox Definition Configuration
- **Name**: `win11-dev`
- **Image**: Windows 11 development image from shared gallery
- **SKU**: `general_i_8c32gb256ssd_v2` (8 cores, 32GB RAM, 256GB SSD)
- **Storage**: 512GB SSD for OS
- **Hibernate**: Disabled (basic setup)

### Resource Organization
- All resources are created in the same resource group
- Uses system-assigned managed identity for the Dev Center
- Basic tagging for resource identification

## Prerequisites

1. Azure subscription with appropriate permissions
2. Azure CLI installed and configured
3. Terraform 1.9.0 or later
4. Access to a shared image gallery with Windows 11 development images

**Note**: You'll need to update the `image_reference_id` in the configuration to point to an actual shared image gallery in your subscription.

## Usage

1. Ensure you're authenticated to Azure:
   ```bash
   az login
   export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)
   ```

2. Update the configuration:
   - Modify the `image_reference_id` to point to your shared image gallery
   - Adjust resource group names and regions as needed

3. Initialize and apply:
   ```bash
   terraform init
   terraform plan -var-file=examples/dev_center_dev_box_definition/simple_case/configuration.tfvars
   terraform apply -var-file=examples/dev_center_dev_box_definition/simple_case/configuration.tfvars
   ```

4. Clean up:
   ```bash
   terraform destroy -var-file=examples/dev_center_dev_box_definition/simple_case/configuration.tfvars
   ```

## Resources Created

This example creates:
- 1 Resource Group
- 1 Dev Center with system-assigned identity
- 1 DevBox Definition with basic configuration

## Notes

- The shared image gallery and image must exist before creating the DevBox Definition
- SKU availability varies by region - ensure the selected SKU is available in your target region
- Consider enabling hibernate support for cost optimization in non-production environments
