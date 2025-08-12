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

  dev_center_projects = {
    project1 = {
      name = "test-project"
      dev_center = {
        key = "devcenter1"
      }
      resource_group = {
        key = "rg1"
      }
      description                = "Test project for environment type linking"
      maximum_dev_boxes_per_user = 2
      tags = {
        environment = "test"
        module      = "dev_center_project"
      }
    }
  }

  dev_center_project_environment_types = {
    // Basic project environment type
    projenvtype1 = {
      name                 = "development"
      display_name         = "Development Environment"
      status               = "Enabled"
      deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
      project = {
        key = "project1"
      }
      resource_group = {
        key = "rg1"
      }
      tags = {
        environment = "test"
        module      = "dev_center_project_environment_type"
        purpose     = "development"
      }
    }
    // Project environment type with role assignments
    projenvtype2 = {
      name                 = "production"
      display_name         = "Production Environment"
      status               = "Enabled"
      deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
      project = {
        key = "project1"
      }
      resource_group = {
        key = "rg1"
      }
      tags = {
        environment = "test"
        module      = "dev_center_project_environment_type"
        purpose     = "production"
      }
      creator_role_assignment = {
        roles = {
          owner = {
            role_definition_id = "/subscriptions/12345678-1234-1234-1234-123456789012/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
          }
        }
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries             = {}
  dev_center_dev_box_definitions   = {}
  dev_center_network_connections   = {}
  dev_center_catalogs              = {}
  dev_center_project_pools         = {}
  dev_center_project_pool_schedules = {}
  shared_image_galleries           = {}
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
        name                 = "development"
        display_name         = "Development Environment"
        status               = "Enabled"
        deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
        project = {
          key = "project1"
        }
        resource_group = {
          key = "rg1"
        }
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
    // Override with project environment type that has role assignments
    dev_center_project_environment_types = {
      projenvtype2 = {
        name                 = "production"
        display_name         = "Production Environment"
        status               = "Enabled"
        deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
        project = {
          key = "project1"
        }
        resource_group = {
          key = "rg1"
        }
        tags = {
          environment = "test"
          module      = "dev_center_project_environment_type"
          purpose     = "production"
        }
        creator_role_assignment = {
          roles = {
            owner = {
              role_definition_id = "/subscriptions/12345678-1234-1234-1234-123456789012/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
            }
          }
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

// Test for disabled project environment type
run "test_project_environment_type_disabled" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Override with disabled project environment type
    dev_center_project_environment_types = {
      projenvtype3 = {
        name                 = "staging"
        display_name         = "Staging Environment"
        status               = "Disabled"
        deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
        project = {
          key = "project1"
        }
        resource_group = {
          key = "rg1"
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
    condition     = module.dev_center_project_environment_types["projenvtype3"] != null
    error_message = "Disabled project environment type module should exist"
  }

  assert {
    condition     = length(keys(module.dev_center_project_environment_types)) == 1
    error_message = "Should only have one project environment type (projenvtype3)"
  }
}