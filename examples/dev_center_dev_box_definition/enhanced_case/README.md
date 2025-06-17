# Enhanced DevBox Definition Example

This example demonstrates an advanced DevBox Definition configuration showcasing multiple definition types with different configurations and use cases.

## Overview

This enhanced example creates four different DevBox Definitions, each optimized for specific development scenarios:

1. **Standard Windows 11 Development** - General-purpose development environment
2. **AI/ML Premium Windows 11** - High-performance environment for AI/ML workloads  
3. **Ubuntu Development** - Linux-based development environment
4. **Data Science Windows 11** - Specialized environment with data science tools

## Architecture

```text
Platform DevCenter
├── win11-standard (Standard Development)
│   ├── SKU: general_i_8c32gb256ssd_v2
│   ├── Storage: 512GB SSD
│   └── Hibernate: Enabled
├── win11-ai-premium (AI/ML Development)
│   ├── SKU: general_i_32c128gb1024ssd_v2
│   ├── Storage: 2TB SSD
│   └── Hibernate: Disabled
├── ubuntu-development (Linux Development)
│   ├── SKU: general_i_16c64gb512ssd_v2
│   ├── Storage: 1TB SSD
│   └── Hibernate: Enabled
└── win11-datascience (Data Science)
    ├── SKU: general_i_16c64gb512ssd_v2
    ├── Storage: 1TB SSD
    └── Hibernate: Enabled
```

## Features Demonstrated

### Image Reference Formats

- **String Format**: `image_reference_id` for direct image references
- **Object Format**: `image_reference.id` for explicit object-based references

### SKU Optimization

- **Standard**: 8 cores, 32GB RAM, 256GB SSD for general development
- **Premium**: 32 cores, 128GB RAM, 1TB SSD for AI/ML workloads
- **Development**: 16 cores, 64GB RAM, 512GB SSD for Linux development
- **Specialized**: 16 cores, 64GB RAM, 512GB SSD for data science

### Storage Configuration

- **512GB**: Standard development workloads
- **1TB**: Linux development and data science
- **2TB**: AI/ML workloads requiring large model storage

### Hibernate Support

- **Enabled**: Cost-optimized environments that can be paused
- **Disabled**: Always-on environments for long-running processes

### Comprehensive Tagging

- Environment classification (standard, premium, specialized)
- Purpose identification (general-development, ai-ml-development, etc.)
- Cost management tags (auto_delete, cost_tier)
- Technical metadata (gpu_enabled, tools)

## Configuration Details

### Global Settings

```hcl
global_settings = {
  prefixes      = ["contoso", "dev"]
  random_length = 5
  passthrough   = false
  use_slug      = true
}
```

### Resource Organization

- **Resource Group**: `rg-devbox-definitions` for organizing DevBox resources
- **DevCenter**: `platform-devcenter` with comprehensive settings
- **Identity**: System-assigned for secure operations

### DevCenter Features

- Azure Monitor Agent enabled for telemetry
- Microsoft-hosted networking for simplicity
- Catalog item synchronization enabled

## Prerequisites

1. **Azure Subscription** with appropriate permissions
2. **Shared Image Gallery** with the referenced images:
   - `win11-dev-standard` - Standard Windows 11 development image
   - `win11-ai-dev` - AI/ML optimized Windows 11 image
   - `ubuntu-22-04-dev` - Ubuntu 22.04 development image
   - `win11-datascience` - Windows 11 with data science tools

3. **Azure DevCenter** quota for the specified SKUs
4. **Storage** quota for the total storage allocation

## Usage

### Deploy the Configuration

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var-file="configuration.tfvars"

# Apply the configuration
terraform apply -var-file="configuration.tfvars"
```

### Verify Deployment

```bash
# List created DevBox Definitions
az devcenter admin devbox-definition list \
  --dev-center-name "platform-devcenter" \
  --resource-group "rg-devbox-definitions"
```

## Cost Considerations

### Performance Tiers

- **Standard** (~$200-400/month): Cost-effective for general development
- **Premium** (~$800-1200/month): High-performance for AI/ML workloads
- **Development** (~$400-600/month): Balanced for intensive development
- **Specialized** (~$400-600/month): Optimized for data science workflows

### Cost Optimization

- **Hibernate Enabled**: Automatic cost savings during idle periods
- **Auto-delete Tags**: Facilitates automated cleanup policies
- **Right-sizing**: SKUs matched to workload requirements

## Security Features

- **System-assigned Identity**: Secure access to Azure resources
- **Resource Group Isolation**: Logical separation of resources
- **Image Gallery Integration**: Centralized, versioned image management
- **Tag-based Governance**: Facilitates policy enforcement

## Customization

### Adding New Definitions

```hcl
dev_center_dev_box_definitions = {
  your_custom_definition = {
    name = "custom-environment"
    dev_center = { key = "platform" }
    resource_group = { key = "rg_devbox" }
    image_reference_id = "your-image-id"
    sku_name = "general_i_8c32gb256ssd_v2"
    hibernate_support = { enabled = true }
  }
}
```

### Image Management

Update image references to use your organization's shared image gallery:

```hcl
image_reference_id = "/subscriptions/{subscription-id}/resourceGroups/{rg-name}/providers/Microsoft.Compute/galleries/{gallery-name}/images/{image-name}/versions/latest"
```

## Troubleshooting

### Common Issues

1. **Image Not Found**: Verify image exists in the specified gallery
2. **SKU Not Available**: Check availability in target region
3. **Quota Exceeded**: Request quota increase for required SKUs
4. **Permission Denied**: Ensure proper RBAC assignments

### Validation

```bash
# Validate Terraform configuration
terraform validate

# Check DevCenter status
az devcenter admin devcenter show \
  --name "platform-devcenter" \
  --resource-group "rg-devbox-definitions"
```

## Related Examples

- [Simple DevBox Definition](../simple_case/README.md) - Basic single definition
- [DevCenter Configuration](../../dev_center/enhanced_case/README.md) - Complete DevCenter setup
- [DevCenter Project](../../dev_center_project/enhanced_case/README.md) - Project management

## References

- [Azure DevBox Documentation](https://docs.microsoft.com/en-us/azure/dev-box/)
- [DevBox Definition API Reference](https://docs.microsoft.com/en-us/rest/api/devcenter/)
- [Terraform AzAPI Provider](https://registry.terraform.io/providers/Azure/azapi/latest/docs)
