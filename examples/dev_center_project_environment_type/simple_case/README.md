# Dev Center Project Environment Type Example - Simple Case

This example demonstrates a basic DevCenter project environment type configuration that links an environment type to a project.

## Overview

This simple configuration creates:

- A DevCenter with basic settings
- A development environment type within the DevCenter
- A project within the DevCenter
- A project environment type that links the development environment type to the project

## Usage

To run this example:

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var-file=examples/dev_center_project_environment_type/simple_case/configuration.tfvars

# Apply the configuration
terraform apply -var-file=examples/dev_center_project_environment_type/simple_case/configuration.tfvars

# Destroy resources when done
terraform destroy -var-file=examples/dev_center_project_environment_type/simple_case/configuration.tfvars
```

## Configuration Details

### DevCenter
- **Name**: `dev-devcenter-xyz` (with naming conventions applied)
- **Location**: East US
- **Environment**: Demo/development

### Environment Type
- **Name**: `development`
- **Display Name**: "Development Environment Type"
- **Scope**: DevCenter level

### Project
- **Name**: `dev-devproject-xyz` (with naming conventions applied)
- **Description**: Development project for testing environment types
- **Scope**: Within the DevCenter

### Project Environment Type
- **Name**: `terraform-env`
- **Environment Type**: Links to the `development` environment type
- **Deployment Target**: Resource group for deployment
- **Scope**: Project level

## Environment Setup

This example requires:

1. **Azure Subscription**: Valid Azure subscription with appropriate permissions
2. **Resource Group**: The deployment target resource group must exist
3. **Permissions**: Sufficient permissions to create DevCenter resources

## Tagging Strategy

All resources include consistent tags:
- `environment`: demo
- `module`: Identifies the specific module
- `purpose`: development

This helps with resource organization and cost allocation.

## Next Steps

After successful deployment, you can:

1. **Verify Resources**: Check the Azure portal to see the created resources
2. **Test Environment Creation**: Use the project environment type to create development environments
3. **Explore Enhanced Case**: Try the enhanced example for more complex scenarios