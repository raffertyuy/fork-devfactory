# Azure Load Test - Simple Case Example

This example demonstrates how to create a basic Azure Load Test resource using the DevFactory load test module.

## Overview

This configuration creates:
- A resource group for hosting the load test
- A basic Azure Load Test service for development purposes

## Configuration

The example includes:
- **Basic Load Test**: A simple load testing service with minimal configuration
- **Resource Group**: A dedicated resource group for the load test resources
- **Global Settings**: Standard naming conventions and tagging

## Usage

1. Navigate to this directory:
   ```bash
   cd examples/load_test/simple_case
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan the deployment:
   ```bash
   terraform plan -var-file="configuration.tfvars"
   ```

4. Apply the configuration:
   ```bash
   terraform apply -var-file="configuration.tfvars"
   ```

## Resources Created

- **Resource Group**: `devfactory-loadtest-resources-001`
- **Load Test**: `devfactory-basic-load-test-001`

## Configuration Details

### Load Test Configuration
- **Name**: `basic-load-test`
- **Description**: Basic load testing service for development
- **Tags**: Includes environment and purpose tags
- **Identity**: None (system default)
- **Encryption**: None (Azure-managed keys)

### Resource Group
- **Name**: `loadtest-resources`
- **Location**: `eastus`

## Cleanup

To remove all resources:
```bash
terraform destroy -var-file="configuration.tfvars"
```

## Next Steps

- Review the [enhanced case example](../enhanced_case/) for advanced features
- Explore identity and encryption configuration options
- Learn about load test execution and monitoring
