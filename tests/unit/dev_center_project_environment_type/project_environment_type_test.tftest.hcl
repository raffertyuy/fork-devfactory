# Dev Center Project Environment Type Module Tests
# Tests for the dev_center_project_environment_type module

# Mock provider configuration for testing
provider "azapi" {
  use_msi = false
  # Mock configuration for unit testing
}

provider "azurecaf" {
  # Mock configuration for unit testing
}

# Mock data sources
mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_id = "12345678-1234-1234-1234-123456789012"
      client_id      = "12345678-1234-1234-1234-123456789012"
      tenant_id      = "12345678-1234-1234-1234-123456789012"
    }
  }
}

# Test 1: Simple project environment type creation
run "simple_project_environment_type" {
  command = plan

  variables {
    global_settings = {
      prefix      = "test"
      environment = "dev"
      location    = "eastus"
      tags = {
        environment = "development"
        project     = "devfactory"
      }
    }

    project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/projects/test-project"
    location   = "eastus"

    project_environment_type = {
      name                = "development"
      environment_type_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/devcenters/test-devcenter/environmentTypes/development"
      deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
      status              = "Enabled"
    }
  }

  # Verify the project environment type resource is planned
  assert {
    condition     = azapi_resource.this != null
    error_message = "Project environment type resource should be created"
  }

  # Verify the naming convention
  assert {
    condition     = azurecaf_name.this.result != null
    error_message = "CAF naming should generate a valid name"
  }
}

# Test 2: Project environment type with identity
run "project_environment_type_with_identity" {
  command = plan

  variables {
    global_settings = {
      prefix      = "test"
      environment = "dev"
      location    = "eastus"
      tags = {
        environment = "development"
        project     = "devfactory"
      }
    }

    project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/projects/test-project"
    location   = "eastus"

    project_environment_type = {
      name                = "production"
      environment_type_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/devcenters/test-devcenter/environmentTypes/production"
      deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
      status              = "Enabled"
      display_name        = "Production Environment"
      
      identity = {
        type = "SystemAssigned"
      }

      role_assignments = {
        creators = [
          {
            principal_id   = "11111111-1111-1111-1111-111111111111"
            principal_type = "User"
            role_definition_id = "/subscriptions/12345678-1234-1234-1234-123456789012/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
          }
        ]
        users = [
          {
            principal_id   = "22222222-2222-2222-2222-222222222222"
            principal_type = "Group"
            role_definition_id = "/subscriptions/12345678-1234-1234-1234-123456789012/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
          }
        ]
      }

      tags = {
        tier = "production"
      }
    }
  }

  # Verify the project environment type resource with identity is planned
  assert {
    condition     = azapi_resource.this != null
    error_message = "Project environment type resource with identity should be created"
  }

  # Verify identity block is present
  assert {
    condition     = length(azapi_resource.this.identity) > 0
    error_message = "Identity block should be present when identity is specified"
  }
}

# Test 3: Project environment type with user-assigned identity
run "project_environment_type_with_user_assigned_identity" {
  command = plan

  variables {
    global_settings = {
      prefix      = "test"
      environment = "dev"
      location    = "eastus"
      tags = {
        environment = "development"
        project     = "devfactory"
      }
    }

    project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/projects/test-project"
    location   = "eastus"

    project_environment_type = {
      name                = "staging"
      environment_type_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/devcenters/test-devcenter/environmentTypes/staging"
      deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
      status              = "Enabled"
      
      identity = {
        type = "UserAssigned"
        identity_ids = [
          "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-identity"
        ]
      }
    }
  }

  # Verify user-assigned identity configuration
  assert {
    condition     = azapi_resource.this.identity[0].type == "UserAssigned"
    error_message = "Identity type should be UserAssigned when specified"
  }
}

# Test 4: Disabled project environment type
run "disabled_project_environment_type" {
  command = plan

  variables {
    global_settings = {
      prefix      = "test"
      environment = "dev"
      location    = "eastus"
      tags = {
        environment = "development"
        project     = "devfactory"
      }
    }

    project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/projects/test-project"
    location   = "eastus"

    project_environment_type = {
      name                = "disabled-env"
      environment_type_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/devcenters/test-devcenter/environmentTypes/disabled"
      deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
      status              = "Disabled"
    }
  }

  # Verify disabled status is properly set
  assert {
    condition     = jsondecode(azapi_resource.this.body).properties.status == "Disabled"
    error_message = "Project environment type status should be Disabled when specified"
  }
}

# Test 5: Validation - Invalid name should fail
run "invalid_name_validation" {
  command = plan

  variables {
    global_settings = {
      prefix      = "test"
      environment = "dev"
      location    = "eastus"
      tags = {
        environment = "development"
        project     = "devfactory"
      }
    }

    project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/projects/test-project"
    location   = "eastus"

    project_environment_type = {
      name                = "Invalid Name With Spaces"
      environment_type_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/devcenters/test-devcenter/environmentTypes/invalid"
      deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
      status              = "Enabled"
    }
  }

  expect_failures = [
    var.project_environment_type
  ]
}

# Test 6: Validation - Invalid status should fail
run "invalid_status_validation" {
  command = plan

  variables {
    global_settings = {
      prefix      = "test"
      environment = "dev"
      location    = "eastus"
      tags = {
        environment = "development"
        project     = "devfactory"
      }
    }

    project_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/projects/test-project"
    location   = "eastus"

    project_environment_type = {
      name                = "valid-name"
      environment_type_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.DevCenter/devcenters/test-devcenter/environmentTypes/valid"
      deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
      status              = "InvalidStatus"
    }
  }

  expect_failures = [
    var.project_environment_type
  ]
}