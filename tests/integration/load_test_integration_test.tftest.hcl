variables {
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
  }

  resource_groups = {
    loadtest_rg = {
      name   = "loadtest-resources"
      region = "eastus"
      tags = {
        environment = "test"
      }
    }
  }

  load_tests = {
    basic_load_test = {
      name = "integration-load-test"
      resource_group = {
        key = "loadtest_rg"
      }
      description = "Integration test load testing service"
      tags = {
        environment = "test"
        module      = "load_test"
        test_type   = "integration"
      }
    }
  }
}

provider "azapi" {
  # Use mock provider for testing
  use_msi = false
}

provider "azurecaf" {}

provider "azurerm" {
  # Use mock provider for testing
  features {}
}

run "load_test_integration_test" {
  command = plan

  assert {
    condition     = length(var.load_tests) == 1
    error_message = "Should define exactly one load test"
  }

  assert {
    condition     = contains(keys(var.load_tests), "basic_load_test")
    error_message = "Load test 'basic_load_test' should be defined"
  }

  assert {
    condition     = var.load_tests["basic_load_test"].name == "integration-load-test"
    error_message = "Load test should have the correct name"
  }

  assert {
    condition     = var.load_tests["basic_load_test"].description == "Integration test load testing service"
    error_message = "Load test should have the correct description"
  }

  assert {
    condition     = var.load_tests["basic_load_test"].resource_group.key == "loadtest_rg"
    error_message = "Load test should reference the correct resource group"
  }
}

run "resource_group_dependency_test" {
  command = plan

  assert {
    condition     = length(var.resource_groups) == 1
    error_message = "Should define exactly one resource group"
  }

  assert {
    condition     = contains(keys(var.resource_groups), "loadtest_rg")
    error_message = "Resource group 'loadtest_rg' should be defined"
  }

  assert {
    condition     = var.resource_groups["loadtest_rg"].name == "loadtest-resources"
    error_message = "Resource group should have the correct name"
  }
}
