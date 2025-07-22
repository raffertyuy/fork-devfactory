# Testing Guide for DevFactory

This guide provides comprehensive information about testing the Terraform modules and configurations in the DevFactory repository.

## Quick Start

**New to testing in DevFactory? Start here!**

### Requirements

- **Terraform v1.12.1 or higher**
- **Azure CLI** (for authentication setup)

### Run All Tests

```bash
./tests/run_tests.sh
```

### Run Tests from VS Code

1. Open Command Palette (⇧⌘P / Ctrl+Shift+P)
2. Type "Tasks: Run Task"
3. Select "Terraform: Run All Tests"

### Run a Specific Module Test

```bash
terraform -chdir=tests/unit/resource_group init
terraform -chdir=tests/unit/resource_group test
```

**Need more details?** Continue reading for comprehensive testing information, writing new tests, and troubleshooting.

---

## Testing Overview

DevFactory uses **Terraform's native testing functionality** with **provider mocking** to verify modules without creating real Azure resources. This approach ensures tests are fast, reliable, and cost-effective.

## Test Structure

```text
tests/
├── run_tests.sh             # Script to run all tests
├── integration/             # Integration tests (multiple modules)
│   └── dev_center_integration_test.tftest.hcl
└── unit/                    # Unit tests (individual modules)
    ├── dev_center/
    ├── dev_center_catalog/
    ├── dev_center_dev_box_definition/
    ├── dev_center_environment_type/
    ├── dev_center_project/
    ├── dev_center_project_pool/
    ├── dev_center_project_pool_schedule/
    └── resource_group/
```

- **Unit Tests**: Validate individual modules in isolation
- **Integration Tests**: Validate interaction between multiple modules

## Running Tests

### All Tests

```bash
# Command line
./tests/run_tests.sh

# VS Code Task
Command Palette → "Tasks: Run Task" → "Terraform: Run All Tests"
```

### Individual Tests

```bash
# Initialize and run
terraform -chdir=tests/unit/[MODULE_NAME] init
terraform -chdir=tests/unit/[MODULE_NAME] test

# With verbose output
terraform -chdir=tests/unit/[MODULE_NAME] test -verbose

# Specific test run
terraform -chdir=tests/unit/[MODULE_NAME] test -run="test_name"
```

## Writing Tests

### Required Test Structure

```hcl
variables {
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
      tags   = { environment = "test" }
    }
  }

  # Empty variables for unused resources (REQUIRED)
  dev_centers = {}
  dev_center_projects = {}
  # ... all other module variables
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

run "test_name" {
  command = plan  # or apply

  module {
    source = "../../../"  # Path to root module
  }

  assert {
    condition     = module.resource_name != null
    error_message = "Resource should exist"
  }
}
```

### Common Test Patterns

**Resource Creation**
```hcl
assert {
  condition     = module.resource_name["key"] != null
  error_message = "Resource should exist"
}
```

**Resource Properties**
```hcl
assert {
  condition     = module.resource_name["key"].location == "eastus"
  error_message = "Resource location should match expected value"
}
```

**Resource Relationships**
```hcl
assert {
  condition     = var.child_resource.parent_resource.key == "parent_key"
  error_message = "Child resource should reference correct parent"
}
```

## Best Practices

- **Mock azapi provider** - Avoid creating real Azure resources
- **Use azurecaf provider directly** - Don't mock naming conventions
- **Include all required variables** - Define empty variables for unused modules
- **Test resource properties and relationships** - Verify expected configurations
- **Use descriptive test names** - Clearly indicate what's being tested
- **Keep unit tests isolated** - Test modules independently
- **Follow existing patterns** - Maintain consistency across tests

## Troubleshooting

### Common Issues

**Version Requirements**
- Terraform v1.12.1+ required
- AzAPI provider v2.4.0+ required

**Missing Variables**
- Define all root module variables, even if empty:
```hcl
variables {
  # ... required variables ...
  dev_centers = {}
  dev_center_projects = {}
  # ... all other module variables
}
```

**Provider Mock Configuration**
- Always include azapi client config mock:
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

**Plan vs Apply Assertions**
- With `command = plan`, only assert on values known during planning
- Some resource properties only available after apply

### Validation Commands

```bash
# Format and validate
terraform fmt -recursive
terraform validate

# Additional validation
tflint --init && tflint
```

## Continuous Integration

Tests run automatically in CI pipelines with colored output and clear success/failure indicators for both local development and CI environments.
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
