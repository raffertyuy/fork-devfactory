# Enhanced Dev Center Project Environment Type Example

This example demonstrates advanced configuration of DevCenter project environment types with role assignments, multiple environments, and comprehensive settings.

## Overview

This example creates:

- A resource group for DevCenter resources
- A corporate DevCenter instance
- Multiple DevCenter environment types (development, staging, production)
- Multiple DevCenter projects (webapp and api)
- Multiple project environment types with advanced configurations

## Configuration Features

The example includes:

- **Multiple environment types**: Development, staging, and production environments
- **Multiple projects**: Separate projects for web application and API development
- **Role assignments**: Granular access control with creator and user role assignments
- **Different deployment targets**: Multiple Azure subscriptions for environment separation
- **Status control**: Some environments initially disabled for approval workflows
- **Managed identities**: System-assigned identity for enhanced security
- **Custom display names**: User-friendly names for environments
- **Comprehensive tagging**: Detailed resource tagging strategy

## Key Features

### Role-Based Access Control (RBAC)

- **Creator roles**: Contributors can create and manage environments
- **User roles**: Readers can view environment details
- **Granular permissions**: Different access levels per environment and project

### Multi-Subscription Deployment

- **Development**: Shared development subscription
- **Staging**: Dedicated staging subscription  
- **Production**: Secure production subscription with restricted access

### Environment Lifecycle Management

- **Development**: Always enabled for active development
- **Staging**: Enabled for testing and validation
- **Production**: Initially disabled, requires approval workflow

## Usage

1. **First, deploy the DevCenter and environment types** to get the actual generated names:

   ```bash
   terraform init
   terraform plan -var-file=examples/dev_center_project_environment_type/enhanced_case/configuration.tfvars
   ```

2. **Update the environment type names** in `configuration.tfvars`:
   - Find the actual generated environment type names from the terraform state or Azure portal
   - Replace `corp-dcet-development-xxx` with the actual development environment type name
   - Replace `corp-dcet-staging-xxx` with the actual staging environment type name  
   - Replace `corp-dcet-production-xxx` with the actual production environment type name

   **Example**: If your environment types are named:
   - `corp-dcet-development-a1b`
   - `corp-dcet-staging-c2d`
   - `corp-dcet-production-e3f`

   Update the configuration:

   ```terraform
   webapp_dev = {
     environment_type_name = "corp-dcet-development-a1b"
     # ... rest of configuration
   }
   ```

3. **Update other settings**:
   - All subscription IDs are set to your current subscription by default
   - Update the user object ID in `user_role_assignments` with actual Azure AD user/group object IDs
   - Modify subscription IDs if you want to use different subscriptions for different environments

4. **Apply the configuration**:

   ```bash
   terraform apply -var-file=examples/dev_center_project_environment_type/enhanced_case/configuration.tfvars
   ```

## Environment Type Name Resolution

The module supports two patterns for referencing environment types:

1. **Explicit environment type name** (recommended for production):

   ```terraform
   environment_type_name = "corp-dcet-development-a1b"  # Exact name
   ```

2. **Direct name** (when you know the exact environment type name):

   ```terraform
   name = "corp-dcet-development-a1b"  # Use environment type name directly
   ```

## Variables Configured

- `global_settings`: Corporate naming conventions and comprehensive tagging
- `resource_groups`: Single resource group for centralized management
- `dev_centers`: Corporate DevCenter instance
- `dev_center_environment_types`: Three environment types (dev, staging, prod)
- `dev_center_projects`: Two projects (webapp and api)
- `dev_center_project_environment_types`: Four project environment type associations

## Project Environment Types Created

### Web Application Project

1. **Development Environment**
   - Creator role: Contributor access
   - User role: Reader access for specific user
   - Custom tags for tracking
   - Always enabled

2. **Staging Environment**
   - Separate subscription for isolation
   - Standard configuration
   - Always enabled

### API Project

1. **Development Environment**
   - System-assigned managed identity
   - Standard configuration
   - Always enabled

2. **Production Environment**
   - Separate production subscription
   - Initially disabled for security
   - Requires manual enablement

## Expected Resources

After deployment, you will have:

1. Resource group: `corp-devcenter-resources-xyz`
2. DevCenter: `corp-corp-devcenter-xyz`
3. Environment types: development, staging, production
4. Projects: `corp-webapp-project-xyz`, `corp-api-project-xyz`
5. Four project environment type associations with various configurations

## Security Considerations

- Different subscriptions provide resource isolation
- Role assignments implement least-privilege access
- Production environments start disabled for approval workflows
- Managed identities enhance security for automated operations

## Dependencies

- Multiple Azure subscriptions with DevCenter service available
- Azure AD users/groups for role assignments
- Appropriate permissions across all target subscriptions
- DevCenter service enabled in all target regions
