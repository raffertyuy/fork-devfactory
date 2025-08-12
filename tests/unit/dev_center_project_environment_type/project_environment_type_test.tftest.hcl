variables {
  global_settings = {
    prefixes      = ["dev"]
    random_length = 3
    passthrough   = false
    use_slug      = true
    regions = {
      primary = "eastus"
    }
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

  dev_center_projects = {
    project1 = {
      name        = "test-project"
      description = "Test project for unit testing"
      dev_center = {
        key = "devcenter1"
      }
      resource_group = {
        key = "rg1"
      }
      tags = {
        environment = "test"
        module      = "dev_center_project"
      }
    }
  }

  dev_center_project_environment_types = {
    // Basic project environment type
    test_proj_env_basic = {
      name                  = "test-basic-env"
      environment_type_name = "development"
      deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-deployment-rg"
      dev_center_project = {
        key = "project1"
      }
      tags = {
        environment = "test"
        module      = "dev_center_project_environment_type"
        test_case   = "basic"
      }
    }
    // Project environment type with role assignments
    test_proj_env_roles = {
      name                  = "test-roles-env"
      environment_type_name = "staging"
      deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-deployment-rg"
      dev_center_project = {
        key = "project1"
      }
      creator_role_assignment = {
        roles = ["Contributor", "User Access Administrator"]
      }
      user_role_assignments = [
        {
          roles   = ["Reader", "Storage Account Contributor"]
          user_id = "test-user@example.com"
        }
      ]
      tags = {
        environment = "test"
        module      = "dev_center_project_environment_type"
        test_case   = "with_roles"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries                 = {}
  dev_center_dev_box_definitions       = {}
  dev_center_network_connections       = {}
  dev_center_catalogs                  = {}
  shared_image_galleries               = {}
  dev_center_project_pools             = {}
  dev_center_project_pool_schedules    = {}
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
      test_proj_env_basic = {
        name                  = "test-basic-env"
        environment_type_name = "development"
        deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-deployment-rg"
        dev_center_project = {
          key = "project1"
        }
        tags = {
          environment = "test"
          module      = "dev_center_project_environment_type"
          test_case   = "basic"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_project_environment_types["test_proj_env_basic"] != null
    error_message = "Basic project environment type module should exist"
  }

  assert {
    condition     = length(keys(module.dev_center_project_environment_types)) == 1
    error_message = "Should only have one project environment type (test_proj_env_basic)"
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
    // Override with only the role-based project environment type
    dev_center_project_environment_types = {
      test_proj_env_roles = {
        name                  = "test-roles-env"
        environment_type_name = "staging"
        deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-deployment-rg"
        dev_center_project = {
          key = "project1"
        }
        creator_role_assignment = {
          roles = ["Contributor", "User Access Administrator"]
        }
        user_role_assignments = [
          {
            roles   = ["Reader", "Storage Account Contributor"]
            user_id = "test-user@example.com"
          }
        ]
        tags = {
          environment = "test"
          module      = "dev_center_project_environment_type"
          test_case   = "with_roles"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_project_environment_types["test_proj_env_roles"] != null
    error_message = "Role-based project environment type module should exist"
  }

  assert {
    condition     = length(keys(module.dev_center_project_environment_types)) == 1
    error_message = "Should only have one project environment type (test_proj_env_roles)"
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
    condition     = module.dev_center_project_environment_types["test_proj_env_basic"] != null
    error_message = "Basic project environment type module should exist"
  }

  assert {
    condition     = module.dev_center_project_environment_types["test_proj_env_roles"] != null
    error_message = "Role-based project environment type module should exist"
  }

  assert {
    condition     = length(keys(module.dev_center_project_environment_types)) == 2
    error_message = "Should have exactly two project environment types"
  }
}