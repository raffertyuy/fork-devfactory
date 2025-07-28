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
      tags = {
        environment = "test"
        module      = "dev_center"
      }
    }
  }

  dev_center_environment_types = {
    // Basic environment type
    development = {
      name         = "development"
      display_name = "Development Environment Type"
      dev_center = {
        key = "devcenter1"
      }
      tags = {
        environment = "test"
        module      = "dev_center_environment_type"
        purpose     = "development"
      }
    }
    // Environment type without display name
    staging = {
      name = "staging"
      dev_center = {
        key = "devcenter1"
      }
      tags = {
        environment = "test"
        module      = "dev_center_environment_type"
        purpose     = "staging"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries                 = {}
  dev_center_dev_box_definitions       = {}
  dev_center_projects                  = {}
  dev_center_project_environment_types = {}
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

// Test for basic environment type with display name
run "test_environment_type_with_display_name" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Override with only the development environment type
    dev_center_environment_types = {
      development = {
        name         = "development"
        display_name = "Development Environment Type"
        dev_center = {
          key = "devcenter1"
        }
        tags = {
          environment = "test"
          module      = "dev_center_environment_type"
          purpose     = "development"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_environment_types["development"] != null
    error_message = "Development environment type module should exist"
  }

  assert {
    condition     = length(keys(module.dev_center_environment_types)) == 1
    error_message = "Should only have one environment type (development)"
  }
}

// Test for environment type without display name
run "test_environment_type_without_display_name" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Override with only the staging environment type
    dev_center_environment_types = {
      staging = {
        name = "staging"
        dev_center = {
          key = "devcenter1"
        }
        tags = {
          environment = "test"
          module      = "dev_center_environment_type"
          purpose     = "staging"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_environment_types["staging"] != null
    error_message = "Staging environment type module should exist"
  }

  assert {
    condition     = length(keys(module.dev_center_environment_types)) == 1
    error_message = "Should only have one environment type (staging)"
  }
}

// Test for multiple environment types
run "test_multiple_environment_types" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_environment_types["development"] != null
    error_message = "Development environment type module should exist"
  }

  assert {
    condition     = module.dev_center_environment_types["staging"] != null
    error_message = "Staging environment type module should exist"
  }

  assert {
    condition     = length(keys(module.dev_center_environment_types)) == 2
    error_message = "Should have two environment types (development and staging)"
  }
}
