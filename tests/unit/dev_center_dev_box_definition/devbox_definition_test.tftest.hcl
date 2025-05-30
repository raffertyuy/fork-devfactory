variables {
  global_settings = {
    prefixes      = ["test"]
    random_length = 3
    passthrough   = false
    use_slug      = true
    tags = {
      environment = "test"
    }
  }

  resource_groups = {
    rg1 = {
      name   = "test-rg"
      region = "eastus"
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

  dev_center_dev_box_definitions = {
    # Test with image_reference_id
    definition1 = {
      name = "test-definition-1"
      dev_center = {
        key = "devcenter1"
      }
      resource_group = {
        key = "rg1"
      }
      image_reference_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.Compute/galleries/testgallery/images/testimage/versions/latest"
      sku_name           = "general_i_8c32gb256ssd_v2"
      hibernate_support = {
        enabled = true
      }
      tags = {
        environment = "test"
        module      = "dev_center_dev_box_definition"
      }
    }

    # Test with image_reference object
    definition2 = {
      name = "test-definition-2"
      dev_center = {
        key = "devcenter1"
      }
      resource_group = {
        key = "rg1"
      }
      image_reference = {
        id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.Compute/galleries/testgallery/images/testimage2/versions/1.0.0"
      }
      sku_name = "general_i_16c64gb512ssd_v2"
      hibernate_support = {
        enabled = false
      }
      tags = {
        environment = "test"
        module      = "dev_center_dev_box_definition"
        test_case   = "image_reference_object"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries                 = {}
  dev_center_projects                  = {}
  dev_center_environment_types         = {}
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

// Test for basic DevBox Definition creation with image_reference_id
run "test_basic_devbox_definition_with_id" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_dev_box_definitions["definition1"] != null
    error_message = "DevBox Definition with image_reference_id should be created"
  }
}

// Test for DevBox Definition creation with image_reference object
run "test_devbox_definition_with_object" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_dev_box_definitions["definition2"] != null
    error_message = "DevBox Definition with image_reference object should be created"
  }
}

// Test hibernate support configuration
run "test_hibernate_support" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = try(module.dev_center_dev_box_definitions["definition1"].hibernate_support, null) != null
    error_message = "Hibernate support should be configured for definition1"
  }
}

// Test storage type configuration
run "test_storage_type" {
  command = plan

  module {
    source = "../../../"
  }
  assert {
    condition     = try(module.dev_center_dev_box_definitions["definition2"].sku, null) != null
    error_message = "SKU should be configured for definition2"
  }
}

// Test naming convention
run "test_naming_convention" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = can(regex("^test-.*", module.dev_center_dev_box_definitions["definition1"].name))
    error_message = "DevBox Definition name should follow naming convention with test prefix"
  }
}
