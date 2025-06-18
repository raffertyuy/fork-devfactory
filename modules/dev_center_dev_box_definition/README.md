# Azure DevCenter DevBox Definition Module

This module creates an Azure DevCenter DevBox Definition using the AzAPI provider with direct Azure REST API access.

## Overview

The DevBox Definition module enables the creation and management of DevBox definitions within Azure DevCenter. It leverages the AzAPI provider to ensure compatibility with the latest Azure features and APIs, following DevFactory standardization patterns.

## Quick Reference

### 🚀 **Most Common Configurations**

```hcl
# Windows 11 + Visual Studio 2022 Enterprise (Recommended for .NET development)
image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"
sku_name = "general_i_16c64gb512ssd_v2"  # 16 vCPU, 64 GB RAM, 512 GB SSD

# Windows 11 Enterprise with Microsoft 365 Apps (Recommended for general development)
image_reference_id = "galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-24h2-ent-cpc-m365"
sku_name = "general_i_8c32gb256ssd_v2"   # 8 vCPU, 32 GB RAM, 256 GB SSD

# High-performance development (AI/ML, large projects)
image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"
sku_name = "general_i_32c128gb1024ssd_v2" # 32 vCPU, 128 GB RAM, 1024 GB SSD
```

### 🔧 **Essential Discovery Commands**
```bash
# List available DevBox SKUs (subscription-wide)
az devcenter admin sku list --output table

# List available images (requires DevCenter context)
az devcenter admin image list --dev-center-name "mydevcenter" --resource-group "myrg" --gallery-name "default" --query "[].name" -o table

# List VM SKUs by location (alternative for region-specific sizing)
az vm list-skus --location "East US" --resource-type "virtualMachines" --query "[?contains(name, 'Standard_D')]" --output table

# Validate your configuration
terraform plan -var-file="configuration.tfvars"
```

## Features

- Uses AzAPI provider v2.4.0 for latest Azure features
- Implements latest Azure DevCenter API (2025-04-01-preview)
- Supports multiple image reference formats
- Configurable SKU and storage options with full type safety
- Hibernate support configuration
- Integrates with azurecaf naming conventions
- Manages resource tags (global + specific)
- Provides strong input validation and type checking
- Schema-aligned object types for Azure API compatibility

## Finding DevBox Configuration Options

### 🖼️ **Finding Available Images**

DevBox definitions support several image sources:

#### **Built-in Gallery Images (Recommended)**
Use the relative path format for Microsoft's built-in images:

```hcl
# Windows 11 with Visual Studio 2022 Enterprise
image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"

# Windows 10 with Visual Studio 2022 Professional
image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win10-m365-gen2"

# Windows 11 Enterprise with Microsoft 365 Apps
image_reference_id = "galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-24h2-ent-cpc-m365"
```

#### **Complete List of Available Built-in Images**
```hcl
# Visual Studio Images
"galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"      # VS 2022 Enterprise + Win11 + M365
"galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win11-m365-gen2"      # VS 2022 Professional + Win11 + M365
"galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win10-m365-gen2"      # VS 2022 Enterprise + Win10 + M365
"galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win10-m365-gen2"      # VS 2022 Professional + Win10 + M365
"galleries/default/images/microsoftvisualstudio_visualstudio2019plustools_vs-2019-ent-general-win11-m365-gen2"  # VS 2019 Enterprise + Win11 + M365
"galleries/default/images/microsoftvisualstudio_visualstudio2019plustools_vs-2019-pro-general-win11-m365-gen2"  # VS 2019 Professional + Win11 + M365
"galleries/default/images/microsoftvisualstudio_visualstudio2019plustools_vs-2019-ent-general-win10-m365-gen2"  # VS 2019 Enterprise + Win10 + M365
"galleries/default/images/microsoftvisualstudio_visualstudio2019plustools_vs-2019-pro-general-win10-m365-gen2"  # VS 2019 Professional + Win10 + M365

# Windows Base Images
"galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-24h2-ent-cpc-m365"  # Windows 11 Enterprise 24H2 + M365
"galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-24h2-ent-cpc"      # Windows 11 Enterprise 24H2
"galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-23h2-ent-cpc-m365" # Windows 11 Enterprise 23H2 + M365
"galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-23h2-ent-cpc"      # Windows 11 Enterprise 23H2
"galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-m365" # Windows 11 Enterprise 22H2 + M365
"galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc"      # Windows 11 Enterprise 22H2
"galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-22h2-ent-cpc-os"   # Windows 11 Enterprise 22H2 + OS Optimizations
"galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win10-22h2-ent-cpc-m365" # Windows 10 Enterprise 22H2 + M365
"galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win10-22h2-ent-cpc"      # Windows 10 Enterprise 22H2

# Developer-Optimized Images
"galleries/default/images/microsoftvisualstudio_windowsplustools_base-win11-gen2"           # Windows 11 + Developer Optimizations 24H2
```

#### **List Available Built-in Images**
```bash
# List all available gallery images
az devcenter admin gallery list --dev-center-name "mydevcenter" --resource-group "myrg"

# Get image details
az devcenter admin image list --dev-center-name "mydevcenter" --resource-group "myrg" --gallery-name "default"
```

#### **Custom Gallery Images**
```hcl
# Full resource ID format
image_reference_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myrg/providers/Microsoft.Compute/galleries/mygallery/images/myimage/versions/1.0.0"

# Or use the object format
image_reference = {
  id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/myrg/providers/Microsoft.Compute/galleries/mygallery/images/myimage"
}
```

### 💻 **Finding Available SKUs**

DevBox SKUs determine the virtual machine size and performance characteristics.

#### **Common SKU Names**
```hcl
# General Purpose - Balanced CPU, Memory, and Storage
"general_i_8c32gb256ssd_v2"    # 8 vCPU, 32 GB RAM, 256 GB SSD
"general_i_16c64gb512ssd_v2"   # 16 vCPU, 64 GB RAM, 512 GB SSD
"general_i_32c128gb1024ssd_v2" # 32 vCPU, 128 GB RAM, 1024 GB SSD

# Memory Optimized - Higher RAM for memory-intensive workloads
"general_i_8c64gb256ssd_v2"    # 8 vCPU, 64 GB RAM, 256 GB SSD
"general_i_16c128gb512ssd_v2"  # 16 vCPU, 128 GB RAM, 512 GB SSD

# Compute Optimized - Higher CPU for compute-intensive workloads
"general_i_8c16gb256ssd_v2"    # 8 vCPU, 16 GB RAM, 256 GB SSD
"general_i_16c32gb512ssd_v2"   # 16 vCPU, 32 GB RAM, 512 GB SSD
```

#### **Complete SKU Reference Table**
| SKU Name | vCPUs | RAM (GB) | Storage (GB) | Use Case | Cost Tier |
|----------|-------|----------|--------------|----------|-----------|
| `general_i_4c16gb128ssd_v2`  | 4  | 16  | 128  | Light development, testing | Low |
| `general_i_8c32gb256ssd_v2`  | 8  | 32  | 256  | Standard development | Medium |
| `general_i_8c64gb256ssd_v2`  | 8  | 64  | 256  | Memory-intensive apps | Medium-High |
| `general_i_16c64gb512ssd_v2` | 16 | 64  | 512  | Heavy development, IDEs | High |
| `general_i_16c128gb512ssd_v2`| 16 | 128 | 512  | Big data, large datasets | High |
| `general_i_32c128gb1024ssd_v2`| 32| 128 | 1024 | AI/ML, enterprise dev | Very High |

#### **SKU Selection Guidelines**
- **👥 Team Size**: Larger teams may benefit from fewer, more powerful DevBoxes
- **🛠️ Workload Type**: Match SKU to your development requirements
- **💰 Budget**: Balance performance needs with cost constraints
- **⏱️ Usage Pattern**: Consider if DevBoxes will be used continuously or intermittently

#### **List Available SKUs by Region**
```bash
# List DevBox SKUs available (subscription-wide, no location filter)
az devcenter admin sku list

# List DevBox SKUs with output formatting
az devcenter admin sku list --output table

# Filter DevBox SKUs for specific families
az devcenter admin sku list --query "[?contains(name, 'general_i')]"

# Alternative: List VM SKUs by location for sizing reference
az vm list-skus --location "East US" --resource-type "virtualMachines" --query "[?contains(name, 'Standard_D')]"
```

#### **Advanced SKU Configuration**
```hcl
# Simple SKU (recommended for most use cases)
sku_name = "general_i_16c64gb512ssd_v2"

# Advanced SKU with additional properties
sku = {
  name = "general_i_16c64gb512ssd_v2"
  tier = "Standard"           # Free, Basic, Standard, Premium
}

# Note: Additional fields like family, size, and capacity are optional
# and should only be used if specifically required by your DevCenter configuration
```

#### **SKU Configuration Guidelines**
- **Simple SKU**: Use `sku_name` for straightforward configurations (recommended)
- **Advanced SKU**: Use `sku` object when you need to specify additional properties like tier
- **Required Fields**: Only `name` is required in the SKU object
- **Optional Fields**: `tier`, `family`, `size`, and `capacity` can be omitted for most use cases

### 💾 **OS Storage Types**

The `os_storage_type` property specifies the storage configuration for the OS disk.

#### **Available Storage Types**
```hcl
# Standard SSD options
os_storage_type = "ssd_256gb"   # 256 GB Standard SSD
os_storage_type = "ssd_512gb"   # 512 GB Standard SSD
os_storage_type = "ssd_1024gb"  # 1024 GB Standard SSD

# Premium SSD options (if supported by SKU)
os_storage_type = "premium_256gb"   # 256 GB Premium SSD
os_storage_type = "premium_512gb"   # 512 GB Premium SSD
os_storage_type = "premium_1024gb"  # 1024 GB Premium SSD
```

#### **Storage Type Guidelines**
- **Standard SSD**: Cost-effective, good performance for most development workloads
- **Premium SSD**: Higher performance, better for I/O intensive applications
- **Size Selection**: Consider your development tools, datasets, and build artifacts storage needs

### 🔍 **Discovery Commands**

#### **Azure CLI Commands for Discovery**
```bash
# List DevCenters in subscription
az devcenter admin devcenter list

# List available DevBox definitions
az devcenter admin devbox-definition list --dev-center-name "mydevcenter" --resource-group "myrg"

# Get DevBox definition details
az devcenter admin devbox-definition show --dev-center-name "mydevcenter" --resource-group "myrg" --name "mydevbox"

# List available images in a gallery
az devcenter admin image list --dev-center-name "mydevcenter" --resource-group "myrg" --gallery-name "default"

# Check image version details
az devcenter admin image-version list --dev-center-name "mydevcenter" --resource-group "myrg" --gallery-name "default" --image-name "microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"

# List DevBox SKUs with detailed output
az devcenter admin sku list --output table

# Get specific SKU details with capabilities
az devcenter admin sku list --query "[?name=='general_i_16c64gb512ssd_v2']"

# Check what image templates are available with structured output
az devcenter admin image list --dev-center-name "mydevcenter" --resource-group "myrg" --gallery-name "default" --query "[].{Name:name,Publisher:publisher,Offer:offer,Sku:sku}"

# Validate if a specific image exists
az devcenter admin image show --dev-center-name "mydevcenter" --resource-group "myrg" --gallery-name "default" --name "microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"

# List VM SKUs by location (for reference/comparison)
az vm list-skus --location "East US" --resource-type "virtualMachines" --output table
```

#### **PowerShell Commands for Discovery**
```powershell
# Install the Az.DevCenter module if not already installed
# Install-Module -Name Az.DevCenter -Scope CurrentUser -Force

# List available DevBox SKUs (note: this may not be DevCenter-specific)
Get-AzComputeResourceSku | Where-Object {$_.ResourceType -eq "virtualMachines"} | Format-Table Name, Locations, Restrictions

# Get DevCenter information
Get-AzDevCenterAdminDevCenter -ResourceGroupName "myrg"

# List DevBox definitions
Get-AzDevCenterAdminDevBoxDefinition -DevCenterName "mydevcenter" -ResourceGroupName "myrg"

# Get available images in default gallery
Get-AzDevCenterAdminImage -DevCenterName "mydevcenter" -ResourceGroupName "myrg" -GalleryName "default"

# Check specific image details
Get-AzDevCenterAdminImage -DevCenterName "mydevcenter" -ResourceGroupName "myrg" -GalleryName "default" -Name "microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"

# List available VM sizes for reference
Get-AzVMSize -Location "East US" | Where-Object {$_.Name -like "*Standard_D*"} | Format-Table Name, NumberOfCores, MemoryInMB, OSDiskSizeInMB

# Get subscription context
Get-AzContext | Format-List Name, Account, Environment, Subscription
```

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

  location      = "East US"
  dev_center_id = "/subscriptions/.../devcenters/mydevcenter"

  dev_box_definition = {
    name               = "win11-dev"
    image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"
    sku_name          = "general_i_8c32gb256ssd_v2"

    hibernate_support = true

    tags = {
      purpose = "development"
      team    = "engineering"
    }
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

    # Simple SKU configuration
    sku_name = "general_i_32c128gb1024ssd_v2"

    hibernate_support = true

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

## Advanced SKU Object Usage

```hcl
module "enterprise_dev_box_definition" {
  source = "./modules/dev_center_dev_box_definition"

  global_settings = {
    prefixes      = ["enterprise"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  location      = "eastus"
  dev_center_id = "/subscriptions/.../devcenters/mydevcenter"

  dev_box_definition = {
    name = "enterprise-development-box"

    # Built-in Azure DevCenter image
    image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-pro-general-win11-m365-gen2"

    # Advanced SKU object configuration
    sku = {
      name = "general_i_16c64gb512ssd_v2"
      tier = "Standard"
    }

    hibernate_support = true

    os_storage_type = "ssd_512gb"

    tags = {
      purpose     = "enterprise-development"
      cost_center = "engineering"
      sku_config  = "advanced"
    }
  }

  tags = {
    managed_by = "terraform"
    module     = "dev_center_dev_box_definition"
  }
}
```

For more examples, see the [DevBox Definition examples](../../../examples/dev_center_dev_box_definition/).

## Ready-to-Use Configuration Templates

### 🏢 **Enterprise .NET Development**
```hcl
module "enterprise_dotnet_devbox" {
  source = "./modules/dev_center_dev_box_definition"

  global_settings = {
    prefixes      = ["corp"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  location      = "East US"
  dev_center_id = "/subscriptions/your-subscription-id/resourceGroups/your-rg/providers/Microsoft.DevCenter/devcenters/your-devcenter"

  dev_box_definition = {
    name               = "enterprise-dotnet-dev"
    image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"
    sku_name          = "general_i_16c64gb512ssd_v2"
    os_storage_type   = "ssd_512gb"

    hibernate_support = true

    tags = {
      purpose     = "enterprise-development"
      team        = "engineering"
      cost_center = "IT"
    }
  }
}
```

### 🐧 **Windows Development Environment**
```hcl
module "windows_devbox" {
  source = "./modules/dev_center_dev_box_definition"

  global_settings = {
    prefixes      = ["dev"]
    random_length = 2
    passthrough   = false
    use_slug      = true
  }

  location      = "West US 2"
  dev_center_id = "/subscriptions/your-subscription-id/resourceGroups/your-rg/providers/Microsoft.DevCenter/devcenters/your-devcenter"

  dev_box_definition = {
    name               = "windows-dev-env"
    image_reference_id = "galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-24h2-ent-cpc-m365"
    sku_name          = "general_i_8c32gb256ssd_v2"
    os_storage_type   = "ssd_256gb"

    hibernate_support = true

    tags = {
      os_type = "windows"
      purpose = "development"
    }
  }
}
```

### 🤖 **AI/ML Development Workstation**
```hcl
module "ai_ml_devbox" {
  source = "./modules/dev_center_dev_box_definition"

  global_settings = {
    prefixes      = ["ai"]
    random_length = 4
    passthrough   = false
    use_slug      = true
  }

  location      = "East US"
  dev_center_id = "/subscriptions/your-subscription-id/resourceGroups/your-rg/providers/Microsoft.DevCenter/devcenters/your-devcenter"

  dev_box_definition = {
    name               = "ai-ml-workstation"
    image_reference_id = "galleries/default/images/microsoftvisualstudio_windowsplustools_base-win11-gen2"
    sku_name          = "general_i_32c128gb1024ssd_v2"
    os_storage_type   = "premium_1024gb"

    hibernate_support = true  # Save costs when not actively training models

    tags = {
      workload_type = "ai-ml"
      gpu_required  = "false"
      cost_center   = "research"
    }
  }
}
```

### 🧪 **Testing and CI/CD Environment**
```hcl
module "testing_devbox" {
  source = "./modules/dev_center_dev_box_definition"

  global_settings = {
    prefixes      = ["test"]
    random_length = 2
    passthrough   = false
    use_slug      = true
  }

  location      = "Central US"
  dev_center_id = "/subscriptions/your-subscription-id/resourceGroups/your-rg/providers/Microsoft.DevCenter/devcenters/your-devcenter"

  dev_box_definition = {
    name               = "automated-testing"
    image_reference_id = "galleries/default/images/microsoftwindowsdesktop_windows-ent-cpc_win11-24h2-ent-cpc"
    sku_name          = "general_i_4c16gb128ssd_v2"  # Minimal resources for testing
    os_storage_type   = "ssd_128gb"

    hibernate_support = false  # Testing environments need quick startup

    tags = {
      purpose     = "automated-testing"
      environment = "ci-cd"
      shutdown    = "auto"
    }
  }
}
```

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
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | ~> 1.2.29 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi"></a> [azapi](#provider\_azapi) | 2.4.0 |
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 1.2.29 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azapi_resource.dev_box_definition](https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource) | resource |
| [azurecaf_name.dev_box_definition](https://registry.terraform.io/providers/aztfmod/azurecaf/latest/docs/resources/name) | resource |
| [azapi_client_config.current](https://registry.terraform.io/providers/Azure/azapi/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dev_box_definition"></a> [dev\_box\_definition](#input\_dev\_box\_definition) | Configuration object for the DevBox Definition | <pre>object({<br/>    name = string<br/><br/>    # Image reference - supports both direct ID and object form<br/>    image_reference_id = optional(string)<br/>    image_reference = optional(object({<br/>      id = string<br/>    }))<br/><br/>    # SKU configuration - supports both simple name and full object<br/>    sku_name = optional(string)<br/>    sku = optional(object({<br/>      name     = string           # Required: The name of the SKU<br/>      capacity = optional(number) # Optional: Integer for scale out/in support<br/>      family   = optional(string) # Optional: Hardware generation<br/>      size     = optional(string) # Optional: Standalone SKU size code<br/>      tier     = optional(string) # Optional: Free, Basic, Standard, Premium<br/>    }))<br/><br/>    # OS Storage type for the Operating System disk<br/>    os_storage_type = optional(string)<br/><br/>    # Hibernate support - simplified boolean (maps to "Enabled"/"Disabled" in API)<br/>    hibernate_support = optional(bool, false)<br/><br/>    # Tags<br/>    tags = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_dev_center_id"></a> [dev\_center\_id](#input\_dev\_center\_id) | The ID of the Dev Center where the DevBox Definition will be created | `string` | n/a | yes |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global settings object for naming conventions and standard parameters | <pre>object({<br/>    prefixes      = list(string)<br/>    random_length = number<br/>    passthrough   = bool<br/>    use_slug      = bool<br/>    tags          = optional(map(string), {})<br/>  })</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the DevBox Definition will be created | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to the DevBox Definition | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_active_image_reference"></a> [active\_image\_reference](#output\_active\_image\_reference) | Image reference information for the currently active image |
| <a name="output_dev_center_id"></a> [dev\_center\_id](#output\_dev\_center\_id) | The ID of the Dev Center |
| <a name="output_hibernate_support"></a> [hibernate\_support](#output\_hibernate\_support) | The hibernate support status |
| <a name="output_id"></a> [id](#output\_id) | The ID of the DevBox Definition |
| <a name="output_image_reference"></a> [image\_reference](#output\_image\_reference) | The image reference configuration |
| <a name="output_image_validation_error_details"></a> [image\_validation\_error\_details](#output\_image\_validation\_error\_details) | Details for image validator error |
| <a name="output_image_validation_status"></a> [image\_validation\_status](#output\_image\_validation\_status) | Validation status of the configured image |
| <a name="output_name"></a> [name](#output\_name) | The name of the DevBox Definition |
| <a name="output_os_storage_type"></a> [os\_storage\_type](#output\_os\_storage\_type) | The storage type used for the Operating System disk |
| <a name="output_provisioning_state"></a> [provisioning\_state](#output\_provisioning\_state) | The provisioning state of the DevBox Definition |
| <a name="output_sku"></a> [sku](#output\_sku) | The SKU configuration |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags assigned to the DevBox Definition |
| <a name="output_validation_status"></a> [validation\_status](#output\_validation\_status) | Validation status for the Dev Box Definition |
<!-- END_TF_DOCS -->

## Validation Rules

The module includes comprehensive validation for:

- **DevBox Definition Name**: Must be 63 characters or less and follow Azure naming conventions
- **Image Reference**: Either `image_reference_id` or `image_reference` object must be provided
- **Dev Center ID**: Must be a valid Azure resource ID format
- **SKU Configuration**: When using SKU object, `name` field is required
- **SKU Tier**: Must be one of: `Free`, `Basic`, `Standard`, `Premium`
- **SKU Capacity**: Must be a positive integer when specified
- **OS Storage Type**: Must follow pattern `(ssd|premium)_(128|256|512|1024)gb`

### Input Validation Examples

#### ✅ **Valid Configurations:**
```hcl
# Valid OS storage types
os_storage_type = "ssd_256gb"
os_storage_type = "premium_512gb"
os_storage_type = "ssd_1024gb"

# Valid SKU configurations
sku_name = "general_i_16c64gb512ssd_v2"

sku = {
  name = "general_i_16c64gb512ssd_v2"
  tier = "Standard"
  capacity = 1
}
```

#### ❌ **Invalid Configurations:**
```hcl
# Invalid OS storage type
os_storage_type = "invalid_storage"  # Error: Must match pattern

# Invalid SKU tier
sku = {
  name = "general_i_16c64gb512ssd_v2"
  tier = "InvalidTier"  # Error: Must be Free, Basic, Standard, or Premium
}

# Invalid SKU capacity
sku = {
  name = "general_i_16c64gb512ssd_v2"
  capacity = -1  # Error: Must be positive integer
}
```

## Troubleshooting Guide

### 🔧 **Common Issues and Solutions**

#### **SKU Not Available Error**
```
Error: The SKU 'general_i_16c64gb512ssd_v2' is not available in region 'West Europe'
```

**Solution**: Check SKU availability in your target region:
```bash
# Check which DevBox SKUs are available (subscription-wide)
az devcenter admin sku list --query "[].name" -o table

# Find alternative DevBox SKUs with similar specs
az devcenter admin sku list --query "[?contains(name, '16c')]"

# Check VM SKUs available in your region (for comparison)
az vm list-skus --location "West Europe" --resource-type "virtualMachines" --query "[?contains(name, 'Standard_D')]"
```

#### **Image Not Found Error**
```
Error: The specified image 'galleries/default/images/nonexistent-image' could not be found
```

**Solution**: Verify image availability and get the correct name:
```bash
# List all available images in the default gallery
az devcenter admin image list --dev-center-name "mydevcenter" --resource-group "myrg" --gallery-name "default" --query "[].name" -o table

# Search for specific image patterns
az devcenter admin image list --dev-center-name "mydevcenter" --resource-group "myrg" --gallery-name "default" --query "[?contains(name, 'visualstudio')]"
```

#### **Hibernate Support Compatibility**
Not all SKUs support hibernation. Check SKU capabilities:
```bash
# Check if a SKU supports hibernation
az devcenter admin sku list --query "[?name=='general_i_8c32gb256ssd_v2'].capabilities"

# List all SKUs with hibernation support
az devcenter admin sku list --query "[?capabilities[?name=='HibernateSupport' && value=='true']].name" -o table
```

#### **Storage Type Validation**
Ensure the `os_storage_type` matches the SKU's storage configuration:
```hcl
# For SKUs with 256GB storage, use matching storage type
sku_name = "general_i_8c32gb256ssd_v2"
os_storage_type = "ssd_256gb"  # ✅ Correct - matches SKU storage

# This would be incorrect:
# os_storage_type = "ssd_512gb"  # ❌ Wrong - doesn't match SKU
```

### 🔍 **Validation Commands**

Before applying your configuration, validate your choices:

```bash
# Validate DevCenter exists and is accessible
az devcenter admin devcenter show --name "mydevcenter" --resource-group "myrg"

# Check if the image exists in the gallery
az devcenter admin image show --dev-center-name "mydevcenter" --resource-group "myrg" --gallery-name "default" --name "YOUR_IMAGE_NAME"

# Verify DevBox SKU availability
az devcenter admin sku list --query "[?name=='YOUR_SKU_NAME']"

# Alternative: Check VM SKU availability in target region
az vm list-skus --location "YOUR_REGION" --resource-type "virtualMachines" --query "[?name=='YOUR_VM_SIZE']"

# Test terraform configuration
terraform plan -var-file="configuration.tfvars"
```

### 🚀 **Performance Optimization Tips**

#### **Choosing the Right SKU**
- **Development**: `general_i_8c32gb256ssd_v2` - Good for general development work
- **Heavy Development**: `general_i_16c64gb512ssd_v2` - Visual Studio, large projects
- **AI/ML Development**: `general_i_32c128gb1024ssd_v2` - Data science, model training
- **Testing/CI**: `general_i_4c16gb128ssd_v2` - Automated testing workloads

#### **Storage Considerations**
- **SSD vs Premium**: Use Premium SSD for I/O intensive workloads
- **Size Planning**: Consider OS (40-60GB) + Tools (20-40GB) + Projects (remaining)
- **Cost vs Performance**: Balance storage performance with budget requirements

#### **Regional Selection**
Choose regions based on:
- **Latency**: Closest to your users/developers
- **SKU Availability**: Some advanced SKUs may not be available in all regions
- **Cost**: Pricing may vary between regions
- **Compliance**: Data residency requirements

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
