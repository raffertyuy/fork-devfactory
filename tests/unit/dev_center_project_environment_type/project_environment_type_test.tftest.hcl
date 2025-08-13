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

  dev_center_projects = {
    project1 = {
      name = "test-project"
      dev_center = {
        key = "devcenter1"
      }
      resource_group = {
        key = "rg1"
      }
      description = "Test project for unit testing"
      identity = {
        type = "SystemAssigned"
      }
      tags = {
        environment = "test"
        module      = "dev_center_project"
      }
    }
  }

  dev_center_project_environment_types = {
    // Basic project environment type
    projenvtype1 = {
      name = "development"
      project = {
        key = "project1"
      }
      deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg"
      status = "Enabled"
      tags = {
        environment = "test"
        module      = "dev_center_project_environment_type"
        purpose     = "development"
      }
    }
    // Project environment type with role assignments
    projenvtype2 = {
      name = "staging"
      project = {
        key = "project1"
      }
      deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg"
      status = "Enabled"
      creator_role_assignment = {
        roles = [
          "b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor
        ]
      }
      user_role_assignments = {
        "dev-team" = {
          roles = [
            "acdd72a7-3385-48ef-bd42-f606fba81ae7" # Reader
          ]
        }
      }
      tags = {
        environment = "test"
        module      = "dev_center_project_environment_type"
        purpose     = "staging"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_environment_types         = {}
  dev_center_galleries                 = {}
  dev_center_dev_box_definitions       = {}
  dev_center_network_connections       = {}
  dev_center_catalogs                  = {}
  dev_center_project_pools             = {}
  dev_center_project_pool_schedules    = {}
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

// Test for basic project environment type
run "test_project_environment_type_basic" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Override with only the basic project environment type
    dev_center_project_environment_types = {
      projenvtype1 = {
        name = "development"
        project = {
          key = "project1"
        }
        deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg"
        status = "Enabled"
        tags = {
          environment = "test"
          module      = "dev_center_project_environment_type"
          purpose     = "development"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_project_environment_types["projenvtype1"] != null
    error_message = "Basic project environment type module should exist"
  }

  assert {
    condition     = length(keys(module.dev_center_project_environment_types)) == 1
    error_message = "Should only have one project environment type (projenvtype1)"
  }
}

// Test for project environment type with role assignments
run "test_project_environment_type_with_roles" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Override with the project environment type that has role assignments
    dev_center_project_environment_types = {
      projenvtype2 = {
        name = "staging"
        project = {
          key = "project1"
        }
        deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg"
        status = "Enabled"
        creator_role_assignment = {
          roles = [
            "b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor
          ]
        }
        user_role_assignments = {
          "dev-team" = {
            roles = [
              "acdd72a7-3385-48ef-bd42-f606fba81ae7" # Reader
            ]
          }
        }
        tags = {
          environment = "test"
          module      = "dev_center_project_environment_type"
          purpose     = "staging"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_project_environment_types["projenvtype2"] != null
    error_message = "Project environment type with roles module should exist"
  }

  assert {
    condition     = length(keys(module.dev_center_project_environment_types)) == 1
    error_message = "Should only have one project environment type (projenvtype2)"
  }
}

// Test for multiple project environment types
run "test_multiple_project_environment_types" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  module { source = "../../../" }

  assert {
    condition     = length(keys(module.dev_center_project_environment_types)) == 2
    error_message = "Should have two project environment types configured"
  }

  assert {
    condition     = module.dev_center_project_environment_types["projenvtype1"] != null
    error_message = "First project environment type should exist"
  }

  assert {
    condition     = module.dev_center_project_environment_types["projenvtype2"] != null
    error_message = "Second project environment type should exist"
  }
}