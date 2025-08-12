# Dev Center Project Environment Type - Simple Case Example

This example demonstrates linking an environment type to a project within a Dev Center, enabling the project to create environments of that type.

## Configuration

This example creates:

- A resource group to contain the Dev Center
- A Dev Center to host the infrastructure
- A Dev Center environment type ("development")
- A Dev Center project
- A project environment type linking the environment type to the project

## Usage

1. Navigate to this directory:

   ```bash
   cd examples/dev_center_project_environment_type/simple_case
   ```

2. Update the `deployment_target_id` in `configuration.tfvars` to use your actual Azure subscription ID.

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
- 1 Dev Center Environment Type
- 1 Dev Center Project
- 1 Dev Center Project Environment Type

## Configuration Details

The project environment type is configured with:
- **Name**: "development"
- **Display Name**: "Project Development Environment"
- **Status**: Enabled (default)
- **Deployment Target**: Azure subscription (configurable)
- **Linking**: Links the "development" environment type to "project1"

This configuration allows users in "project1" to create development environments using the "development" environment type.

## Clean Up

To remove all resources:

```bash
terraform destroy -var-file=configuration.tfvars
```

## Notes

- The deployment target ID should be set to a valid Azure subscription or resource group where environments will be created.
- The project environment type inherits permissions and settings from both the project and the environment type.
- Users must have appropriate permissions on both the project and the deployment target to create environments.