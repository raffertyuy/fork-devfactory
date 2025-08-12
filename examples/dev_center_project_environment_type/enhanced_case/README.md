# Dev Center Project Environment Type Example - Enhanced Case

This example demonstrates an enterprise-ready DevCenter project environment type configuration with multiple projects, environment types, and comprehensive role-based access control.

## Overview

This enhanced configuration creates:

- An enterprise DevCenter with production-grade settings
- Multiple environment types (development, staging, production)
- Two team-specific projects (web applications and API services)
- Multiple project environment types with different access controls
- Comprehensive tagging and governance

## DevCenter Features Enabled

- **Azure Monitor Agent**: Enabled for dev box monitoring and telemetry
- **Microsoft-Hosted Network**: Enabled for simplified networking
- **Catalog Item Sync**: Enabled for automatic propagation to projects
- **Auto-deployment**: AI services, serverless GPU sessions, and workspace storage
- **Auto-delete**: Configured for cost optimization with grace periods

## Project Environment Types Created

### Web Team Project Environment Types

1. **Web Development Environment**
   - **Environment Type**: development
   - **Deployment Target**: Shared deployment resource group
   - **Creator Roles**: Contributor, User Access Administrator
   - **Developer Access**: Reader, Web Plan Contributor
   - **Team Lead Access**: Contributor

2. **Web Staging Environment**
   - **Environment Type**: staging
   - **Deployment Target**: Shared deployment resource group
   - **Creator Roles**: Contributor
   - **Developer Access**: Reader only
   - **Team Lead Access**: Contributor, User Access Administrator

### API Team Project Environment Types

1. **API Development Environment**
   - **Environment Type**: development
   - **Deployment Target**: Shared deployment resource group
   - **Creator Roles**: Contributor, Storage Account Contributor
   - **Developer Access**: Reader, API Management Service Reader
   - **Team Lead Access**: Contributor, User Access Administrator

2. **API Production Environment**
   - **Environment Type**: production
   - **Deployment Target**: Shared deployment resource group
   - **Creator Roles**: Reader only (restricted)
   - **Developer Access**: Reader only
   - **Team Lead Access**: Contributor
   - **Platform Admin Access**: Owner

## Usage

To run this example:

```bash
# Initialize Terraform
terraform init

# Plan the deployment
terraform plan -var-file=examples/dev_center_project_environment_type/enhanced_case/configuration.tfvars

# Apply the configuration
terraform apply -var-file=examples/dev_center_project_environment_type/enhanced_case/configuration.tfvars

# Destroy resources when done
terraform destroy -var-file=examples/dev_center_project_environment_type/enhanced_case/configuration.tfvars
```

## Security and Governance

### Role-Based Access Control

- **Environment Creators**: Different role assignments based on environment type
- **Developers**: Limited access to development environments, read-only for production
- **Team Leads**: Enhanced permissions for team management
- **Platform Administrators**: Full control over production environments

### Tagging Strategy

#### Infrastructure Tags (Applied to all resources)
- `business_unit`: engineering
- `cost_center`: development
- `project`: devcenter-platform
- `owner`: platform-team

#### Resource-Specific Tags
- `environment`: production (infrastructure tier)
- `module`: Identifies the specific module
- `team`: Team ownership (web_development, api_development)
- `purpose`: Environment purpose (development, staging, production)
- `tier`: Service tier (standard, premium)
- `criticality`: For production workloads
- `backup_required`: Backup policy flag
- `audit_required`: Audit logging flag

### Environment Governance

- **Development**: Open access for rapid development
- **Staging**: Controlled access for testing and validation
- **Production**: Highly restricted access with approval workflows

## Advanced Features

### Project Configuration

#### Web Team Project
- **Dev Box Limit**: 3 per user
- **AI Services**: Auto-deployed
- **Catalog Sync**: Environment and image definitions
- **User Customizations**: Enabled
- **Auto-delete**: 24-hour inactivity threshold, 4-hour grace period

#### API Team Project
- **Dev Box Limit**: 5 per user
- **Serverless GPU**: Auto-deployed with 10 concurrent sessions
- **Workspace Storage**: Auto-deployed
- **System Identity**: Enabled for Azure service integration

### Environment Types

- **Development**: Standard tier for daily development work
- **Staging**: Premium tier for pre-production testing
- **Production**: Premium tier with high criticality and backup requirements

## Monitoring and Compliance

- **Azure Monitor**: Enabled for telemetry and diagnostics
- **Audit Logging**: Required for production environments
- **Backup Policy**: Enforced for critical environments
- **Cost Optimization**: Auto-delete policies to manage costs

## Best Practices Demonstrated

1. **Separation of Concerns**: Different projects for different teams
2. **Least Privilege Access**: Role assignments based on environment criticality
3. **Environment Progression**: Clear development → staging → production flow
4. **Cost Management**: Auto-delete policies and resource limits
5. **Governance**: Comprehensive tagging and audit requirements
6. **Security**: Identity-based access control and network restrictions

## Next Steps

After deployment, you can:

1. **Verify Deployment**: Check Azure portal for all created resources
2. **Test Access Controls**: Validate role assignments work as expected
3. **Create Environments**: Use the project environment types to deploy resources
4. **Monitor Usage**: Review Azure Monitor data and cost allocation
5. **Customize Further**: Adjust role assignments and policies as needed