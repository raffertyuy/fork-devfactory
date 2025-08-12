# Dev Center Project Environment Type - Enhanced Case Example

This example demonstrates advanced configuration of project environment types within a Dev Center, showing multiple projects with different environment types and role assignments.

## Configuration

This example creates:

- A resource group to contain the Dev Center infrastructure
- A Dev Center with enhanced settings
- Multiple environment types (development, staging, production)
- Multiple projects (frontend and backend applications)
- Multiple project environment type associations with different configurations

## Usage

1. Navigate to this directory:

   ```bash
   cd examples/dev_center_project_environment_type/enhanced_case
   ```

2. Update the `deployment_target_id` values in `configuration.tfvars` to use your actual Azure subscription and resource group IDs.

3. Initialize Terraform:

   ```bash
   terraform init
   ```

4. Plan the deployment:

   ```bash
   terraform plan -var-file=configuration.tfvars
   ```

5. Apply the configuration:

   ```bash
   terraform apply -var-file=configuration.tfvars
   ```

## Resources Created

- 1 Resource Group
- 1 Dev Center
- 3 Dev Center Environment Types (development, staging, production)
- 2 Dev Center Projects (frontend-app, backend-api)
- 4 Dev Center Project Environment Types

## Configuration Highlights

### Environment Types
- **Development**: For active development work
- **Staging**: For testing and validation
- **Production**: For production deployments (restricted access)

### Projects
- **Frontend Project**: Web portal application
- **Backend Project**: API service application

### Project Environment Type Associations

1. **Frontend Development**
   - Enabled for immediate use
   - Full Contributor and DevCenter Dev Box User roles
   - Deploys to subscription level

2. **Frontend Staging**
   - Enabled for testing
   - Contributor role for deployments
   - Deploys to subscription level

3. **Backend Development**
   - Enabled for development
   - Enhanced permissions including Storage Blob Data Contributor
   - Deploys to dedicated resource group

4. **Backend Production**
   - **Disabled by default** for safety
   - Limited Reader permissions
   - Deploys to dedicated production resource group

## Key Features Demonstrated

- **Multiple Environment Types**: Different types for different stages of development
- **Project Separation**: Different projects for different application components
- **Role-Based Access**: Different permissions for different environment types
- **Deployment Targets**: Both subscription and resource group level targets
- **Status Management**: Enabled/disabled status for environment types
- **Enhanced Tagging**: Comprehensive tagging strategy for organization

## Security Considerations

- Production environment type is disabled by default
- Production has limited permissions (Reader only)
- Different deployment targets isolate environments
- Role assignments are environment-specific

## Clean Up

To remove all resources:

```bash
terraform destroy -var-file=configuration.tfvars
```

## Notes

- Ensure the deployment target resource groups exist before applying
- Production environment type should be enabled only when ready for production use
- Role assignments require appropriate permissions on the deployment targets
- Consider implementing additional governance policies for production environments