# Test variables for load test configuration
variables {
  global_settings = {
    prefixes      = ["test"]
    suffixes      = ["001"]
    random_length = 0
    passthrough   = false
    use_slug      = true
    separator     = "-"
    tags = {
      environment = "test"
      project     = "unit-test"
    }
  }

  resource_groups = {
    loadtest_rg = {
      name   = "test-loadtest-resources"
      region = "eastus"
      tags = {
        environment = "test"
      }
    }
  }

  load_tests = {
    basic_load_test = {
      name               = "test-load-test"
      resource_group_key = "loadtest_rg"
      description        = "Test load testing service"
      tags = {
        purpose = "testing"
      }
    }
  }

  # Empty variables required by the root module
  dev_centers                          = {}
  dev_center_galleries                 = {}
  dev_center_dev_box_definitions       = {}
  dev_center_projects                  = {}
  dev_center_environment_types         = {}
  dev_center_project_environment_types = {}
  dev_center_project_pools             = {}
  dev_center_project_pool_schedules    = {}
  dev_center_network_connections       = {}
  dev_center_catalogs                  = {}
  shared_image_galleries               = {}
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

# Test basic load test creation
run "test_basic_load_test" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  module { source = "../../../" }

  assert {
    condition     = module.load_tests["basic_load_test"] != null
    error_message = "Basic load test module should exist"
  }

  assert {
    condition     = length(keys(module.load_tests)) == 1
    error_message = "Should only have one load test (basic_load_test)"
  }
}

# Test load test with system-assigned identity
run "test_load_test_with_system_identity" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    load_tests = {
      identity_load_test = {
        name               = "identity-load-test"
        resource_group_key = "loadtest_rg"
        identity = {
          type = "SystemAssigned"
        }
        tags = {
          purpose = "identity-testing"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.load_tests["identity_load_test"] != null
    error_message = "Identity load test module should exist"
  }

  assert {
    condition     = length(keys(module.load_tests)) == 1
    error_message = "Should only have one load test (identity_load_test)"
  }
}

# Test load test with encryption
run "test_load_test_with_encryption" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    load_tests = {
      encrypted_load_test = {
        name               = "encrypted-load-test"
        resource_group_key = "loadtest_rg"
        identity = {
          type = "SystemAssigned"
        }
        encryption = {
          identity = {
            type = "SystemAssigned"
          }
          key_url = "https://test-vault.vault.azure.net/keys/test-key/version"
        }
        tags = {
          purpose = "encryption-testing"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.load_tests["encrypted_load_test"] != null
    error_message = "Encrypted load test module should exist"
  }

  assert {
    condition     = length(keys(module.load_tests)) == 1
    error_message = "Should only have one load test (encrypted_load_test)"
  }
}

# Test multiple load tests
run "test_multiple_load_tests" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    load_tests = {
      basic_load_test = {
        name               = "basic-load-test"
        resource_group_key = "loadtest_rg"
        description        = "Basic load testing service"
        tags = {
          purpose = "basic-testing"
        }
      }
      advanced_load_test = {
        name               = "advanced-load-test"
        resource_group_key = "loadtest_rg"
        description        = "Advanced load testing service"
        identity = {
          type = "SystemAssigned"
        }
        tags = {
          purpose = "advanced-testing"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.load_tests["basic_load_test"] != null
    error_message = "Basic load test module should exist"
  }

  assert {
    condition     = module.load_tests["advanced_load_test"] != null
    error_message = "Advanced load test module should exist"
  }

  assert {
    condition     = length(keys(module.load_tests)) == 2
    error_message = "Should have two load tests"
  }
}
