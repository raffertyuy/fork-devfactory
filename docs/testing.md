# Testing Guide for DevFactory

This guide provides comprehensive information about testing the Terraform modules and configurations in the DevFactory repository.

## Testing Overview

DevFactory uses Terraform's native testing functionality to verify that modules correctly create resources with expected properties and that modules work together as intended. The tests use provider mocking to avoid creating real Azure resources during testing, making them fast, reliable, and cost-effective.

## Test Structure

The tests are organized into two main categories:

```text
tests/
├── run_tests.sh             # Script to run all tests
├── integration/             # Integration tests that test multiple modules together
│   └── dev_center_integration_test.tftest.hcl
└── unit/                    # Unit tests for individual modules
    ├── dev_center/
    │   └── dev_centers_test.tftest.hcl
    ├── dev_center_catalog/
    │   └── catalog_test.tftest.hcl
    ├── dev_center_dev_box_definition/
    │   └── devbox_definition_test.tftest.hcl
    ├── dev_center_environment_type/
    │   └── environment_type_test.tftest.hcl
    ├── dev_center_project/
    │   └── project_test.tftest.hcl
    ├── dev_center_project_pool/
    │   ├── pool_test.tftest.hcl
    │   └── pool_test_simple.tftest.hcl
    ├── dev_center_project_pool_schedule/
    │   ├── schedule_test.tftest.hcl
    │   └── schedule_test_simple.tftest.hcl
    └── resource_group/
        └── resource_group_test.tftest.hcl
```

### Unit Tests

Unit tests validate individual modules in isolation:

- **Resource Group**: Tests basic resource group creation and custom tags
- **Dev Center**: Tests various identity configurations (System, User, and combined)
- **Dev Center Catalog**: Tests catalog creation with GitHub integration
- **Dev Center Dev Box Definition**: Tests dev box definition configurations
- **Dev Center Environment Type**: Tests environment type creation with various configurations
- **Dev Center Project**: Tests project creation with basic and custom properties
- **Dev Center Project Pool**: Tests project pool configurations
- **Dev Center Project Pool Schedule**: Tests project pool scheduling

### Integration Tests

Integration tests validate the interaction between multiple modules, ensuring they work together correctly. The current integration test creates a complete DevCenter infrastructure including resource groups, dev centers, projects, environment types, and catalogs.

## Running Tests

### Prerequisites

- Terraform v1.12.1 or higher
- Provider configurations for AzAPI and AzureCAF
- Azure CLI (for authentication setup)

### Running All Tests

To run all tests in the repository, use the provided script:

```bash
./tests/run_tests.sh
```

This script will:

1. Initialize the root configuration
2. Discover and initialize all test directories
3. Run unit tests for each module
4. Run integration tests
5. Provide a summary of test results

#### Using VS Code Tasks

You can also run tests directly from VS Code using the built-in tasks:

1. Open the Command Palette (⇧⌘P on macOS or Ctrl+Shift+P on Windows/Linux)
2. Type "Tasks: Run Task" and select it
3. Choose "Terraform: Run All Tests" to run all tests

This executes the same script but provides a convenient way to run tests without leaving the editor.

### Running Individual Tests

To run a specific test, you need to initialize the test directory first and then run the test:

```bash
# Initialize the test directory
terraform -chdir=tests/unit/resource_group init

# Run the test
terraform -chdir=tests/unit/resource_group test
```

### Running Tests with Verbose Output

To see more details during test execution:

```bash
terraform -chdir=tests/unit/resource_group test -verbose
```

### Running Specific Test Runs

To run a specific test run block within a test file:

```bash
terraform -chdir=tests/unit/resource_group test -run="test_basic_resource_group"
```

## Test Implementation

### Provider Mocking

The tests use Terraform's provider mocking capabilities to avoid creating real Azure resources. The `azapi` provider is mocked to return predefined values, while the `azurecaf` provider is used directly for naming conventions.

Example of provider mocking in a test file:

```hcl
mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_id = "12345678-1234-1234-1234-123456789012"
      tenant_id       = "12345678-1234-1234-1234-123456789012"
      client_id       = "12345678-1234-1234-1234-123456789012"
    }
  }
}

mock_provider "azurecaf" {}
```

### Test File Structure

Each test file follows this structure:

```hcl
variables {
  # Global settings for naming conventions
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  # Resource-specific variables
  resource_groups = {
    rg1 = {
      name   = "test-resource-group"
      region = "eastus"
      tags = {
        environment = "test"
      }
    }
  }

  # Empty variables required by the root module
  dev_centers = {}
  # ... other empty variables
}

mock_provider "azapi" {
  # Mock configuration
}

mock_provider "azurecaf" {}

run "test_name" {
  command = plan  # or apply

  variables {
    # Test-specific variable overrides
  }

  module {
    source = "../../../"  # Path to the module being tested
  }

  assert {
    condition     = module.resource_name != null
    error_message = "Error message"
  }
}
```

### Writing New Tests

When writing tests for DevFactory modules, follow these patterns:

#### Unit Test Example

```hcl
variables {
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  resource_groups = {
    rg1 = {
      name   = "test-resource-group"
      region = "eastus"
      tags = {
        environment = "test"
      }
    }
  }

  # Include all required empty variables for the root module
  dev_centers = {}
  dev_center_projects = {}
  # ... etc
}

mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_id = "12345678-1234-1234-1234-123456789012"
      tenant_id       = "12345678-1234-1234-1234-123456789012"
      client_id       = "12345678-1234-1234-1234-123456789012"
    }
  }
}

mock_provider "azurecaf" {}

run "resource_group_creation" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.resource_groups["rg1"] != null
    error_message = "Resource group should exist"
  }

  assert {
    condition     = module.resource_groups["rg1"].location == "eastus"
    error_message = "Resource group location should match expected value"
  }
}
```

#### Integration Test Example

```hcl
variables {
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  resource_groups = {
    rg1 = {
      name   = "test-resource-group"
      region = "eastus"
      tags = {
        environment = "test"
      }
    }
  }

  dev_centers = {
    devcenter1 = {
      name = "test-dev-center"
      resource_group = {
        key = "rg1"
      }
      identity = {
        type = "SystemAssigned"
      }
      tags = {
        environment = "test"
        module      = "dev_center"
      }
    }
  }

  # Include other resources as needed
}

mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_id = "12345678-1234-1234-1234-123456789012"
      tenant_id       = "12345678-1234-1234-1234-123456789012"
      client_id       = "12345678-1234-1234-1234-123456789012"
    }
  }
}

mock_provider "azurecaf" {}

run "full_infrastructure_creation" {
  command = plan

  module {
    source = "../../"
  }

  assert {
    condition     = module.resource_groups["rg1"] != null
    error_message = "Resource group should exist"
  }

  assert {
    condition     = module.dev_centers["devcenter1"] != null
    error_message = "Dev center should exist"
  }

  # Test relationships between resources
  assert {
    condition     = var.dev_centers.devcenter1.resource_group.key == "rg1"
    error_message = "Dev center should reference the correct resource group"
  }
}
```

## Best Practices

When writing tests for DevFactory, follow these best practices:

1. **Mock the azapi provider**: Use provider mocking to avoid creating real Azure resources during testing
2. **Use the azurecaf provider directly**: The azurecaf provider should be used directly, not mocked, for naming conventions
3. **Test resource properties**: Verify that resources are created with the expected properties
4. **Test resource relationships**: Verify that resources are correctly associated with each other
5. **Include all required variables**: Ensure all variables required by the root module are defined, even if empty
6. **Use descriptive test names**: Name test runs clearly to indicate what is being tested
7. **Focus assertions appropriately**: For `plan` tests, only assert on values available during planning
8. **Test multiple configurations**: Test both basic and advanced configurations
9. **Keep tests isolated**: Unit tests should test modules in isolation
10. **Follow existing patterns**: When adding new tests, follow the existing pattern for consistency

## Common Testing Patterns

### Testing Resource Creation

```hcl
assert {
  condition     = module.resource_name["key"] != null
  error_message = "Resource should exist"
}
```

### Testing Resource Properties

```hcl
assert {
  condition     = module.resource_name["key"].location == "eastus"
  error_message = "Resource location should match expected value"
}
```

### Testing Resource Relationships

```hcl
assert {
  condition     = var.child_resource.parent_resource.key == "parent_key"
  error_message = "Child resource should reference the correct parent"
}
```

### Testing Variable Values

```hcl
assert {
  condition     = var.resource_config.property == "expected_value"
  error_message = "Variable should have expected value"
}
```

## Troubleshooting

If you encounter issues when running tests, check the following:

### Common Issues

1. **Terraform version**: Ensure you are using Terraform version 1.12.1 or higher
2. **Provider versions**: Ensure you are using compatible provider versions (AzAPI v2.4.0)
3. **Test file structure**: Ensure the test file follows the correct structure
4. **Module source paths**: Ensure the module source paths are correctly specified
5. **Variable definitions**: Ensure all required variables are defined
6. **Initialization**: Ensure test directories are properly initialized

### Unknown Values in Plan

When using `command = plan`, only assert on values that are known during planning. Some resource properties may only be available after apply.

### Missing Variable Errors

Ensure all variables required by the root module are defined in the test file, even if they are empty:

```hcl
variables {
  # Required variables
  global_settings = { ... }
  resource_groups = { ... }
  
  # Empty variables for unused resources
  dev_centers = {}
  dev_center_projects = {}
  dev_center_catalogs = {}
  # ... etc
}
```

### Provider Mock Configuration

Ensure the azapi provider mock includes the client config data:

```hcl
mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_id = "12345678-1234-1234-1234-123456789012"
      tenant_id       = "12345678-1234-1234-1234-123456789012"
      client_id       = "12345678-1234-1234-1234-123456789012"
    }
  }
}
```

## Validation Commands

Before running tests, you can validate your Terraform configuration:

```bash
# Format Terraform files
terraform fmt -recursive

# Validate Terraform configuration
terraform validate

# Run TFLint for additional validation
tflint --init && tflint
```

These commands are also available as VS Code tasks and should be run before committing changes.

## Continuous Integration

Tests are automatically run in CI pipelines to ensure code quality and prevent regressions. The test runner script provides colored output and clear success/failure indicators suitable for both local development and CI environments.
