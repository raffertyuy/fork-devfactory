# Simple Dev Center Project Environment Type Example

This example demonstrates the basic configuration of a DevCenter project environment type with minimal settings.

## Overview

This example creates:

- A resource group for DevCenter resources
- A DevCenter instance
- A DevCenter environment type (at the DevCenter level)
- A DevCenter project
- A project environment type that enables the "development" environment type for the "webapp-project" project

## Configuration

The example includes:

- **Basic project environment type**: Associates the "development" environment type with the webapp project
- **Deployment target**: Specifies a target subscription for environment deployments
- **Status**: Enabled to allow environment creation

## Key Features

- Minimal configuration with sensible defaults
- Uses naming conventions with prefixes
- Single subscription deployment target
- Environment type enabled by default

## Usage

1. Update the `deployment_target_id` in `configuration.tfvars` with your actual subscription ID

2. **Important**: The configuration uses the exact environment type name that matches the DevCenter environment type. In this example, both the DevCenter environment type and project environment type use `"demo-dcet-development-jsm"` as the name.

3. Run terraform commands:

   ```bash
   terraform init
   terraform plan -var-file=examples/dev_center_project_environment_type/simple_case/configuration.tfvars
   terraform apply -var-file=examples/dev_center_project_environment_type/simple_case/configuration.tfvars
   ```

## Environment Type Name Pattern

This example demonstrates the **direct name** pattern where the project environment type uses the exact DevCenter environment type name:

```terraform
dev_center_project_environment_types = {
  webapp_dev = {
    name = "demo-dcet-development-jsm"  # Must match the DevCenter environment type name
    project = { key = "webapp" }
    deployment_target_id = "/subscriptions/..."
  }
}
```

**Alternative pattern** using explicit environment_type_name:

```terraform
dev_center_project_environment_types = {
  webapp_dev = {
    name = "my-custom-reference-name"
    environment_type_name = "demo-dcet-development-jsm"  # Exact DevCenter env type name
    project = { key = "webapp" }
    deployment_target_id = "/subscriptions/..."
  }
}
```

## Variables Configured

- `global_settings`: Basic naming and tagging configuration
- `resource_groups`: Single resource group for all resources
- `dev_centers`: Single DevCenter instance
- `dev_center_environment_types`: Global environment type definition
- `dev_center_projects`: Single project for web application development
- `dev_center_project_environment_types`: Associates environment type with project

## Expected Resources

After deployment, you will have:

1. Resource group named like `demo-devcenter-resources-xyz` (where xyz is random)
2. DevCenter named like `demo-demo-devcenter-xyz`
3. Environment type at DevCenter level: `development`
4. Project named like `demo-webapp-project-xyz`
5. Project environment type linking the development environment to the webapp project

## Dependencies

- Azure subscription with DevCenter service available
- Appropriate permissions to create DevCenter resources
- Valid subscription ID for the deployment target
