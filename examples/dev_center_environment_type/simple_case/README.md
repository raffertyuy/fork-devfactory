# Dev Center Environment Type - Simple Case Example

This example demonstrates a basic deployment of a Dev Center Environment Type within a Dev Center.

## Configuration

This example creates:

- A resource group to contain the Dev Center
- A Dev Center to host the environment type
- A single environment type named "development"

## Usage

1. Navigate to this directory:

   ```bash
   cd examples/dev_center_environment_type/simple_case
   ```

2. Initialize Terraform:

   ```bash
   terraform init
   ```

3. Plan the deployment:

   ```bash
   terraform plan -var-file=configuration.tfvars
   ```

4. Apply the configuration:

   ```bash
   terraform apply -var-file=configuration.tfvars
   ```

## Resources Created

- 1 Resource Group
- 1 Dev Center
- 1 Dev Center Environment Type

## Clean Up

To remove all resources:

```bash
terraform destroy -var-file=configuration.tfvars
```
