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
      hibernate_support  = true
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
      sku_name          = "general_i_16c64gb512ssd_v2"
      hibernate_support = false
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

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Override with only the first definition
    dev_center_dev_box_definitions = {
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
        hibernate_support  = true
        tags = {
          environment = "test"
          module      = "dev_center_dev_box_definition"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_dev_box_definitions["definition1"] != null
    error_message = "DevBox Definition with image_reference_id should be created"
  }

  assert {
    condition     = length(keys(module.dev_center_dev_box_definitions)) == 1
    error_message = "Should only have one DevBox definition"
  }
}

// Test for DevBox Definition creation with image_reference object
run "test_devbox_definition_with_object" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Override with only the second definition
    dev_center_dev_box_definitions = {
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
        sku_name          = "general_i_16c64gb512ssd_v2"
        hibernate_support = false
        tags = {
          environment = "test"
          module      = "dev_center_dev_box_definition"
          test_case   = "image_reference_object"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_dev_box_definitions["definition2"] != null
    error_message = "DevBox Definition with image_reference object should be created"
  }

  assert {
    condition     = length(keys(module.dev_center_dev_box_definitions)) == 1
    error_message = "Should only have one DevBox definition (definition2)"
  }
}

// Test hibernate support configuration
run "test_hibernate_support" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Test with hibernate enabled
    dev_center_dev_box_definitions = {
      hibernate_enabled = {
        name = "test-hibernate-enabled"
        dev_center = {
          key = "devcenter1"
        }
        resource_group = {
          key = "rg1"
        }
        image_reference_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.Compute/galleries/testgallery/images/testimage/versions/latest"
        sku_name           = "general_i_8c32gb256ssd_v2"
        hibernate_support  = true
        tags = {
          test_case = "hibernate_enabled"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_dev_box_definitions["hibernate_enabled"] != null
    error_message = "DevBox Definition with hibernate support should be planned for creation"
  }
}

// Test storage type configuration
run "test_storage_type" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Test with OS storage type
    dev_center_dev_box_definitions = {
      storage_test = {
        name = "test-storage-type"
        dev_center = {
          key = "devcenter1"
        }
        resource_group = {
          key = "rg1"
        }
        image_reference_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.Compute/galleries/testgallery/images/testimage/versions/latest"
        sku_name           = "general_i_16c64gb512ssd_v2"
        os_storage_type    = "ssd_1024gb"
        hibernate_support  = false
        tags = {
          test_case = "storage_type"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_dev_box_definitions["storage_test"] != null
    error_message = "DevBox Definition with OS storage type should be planned for creation"
  }
}

// Test advanced SKU configuration
run "test_advanced_sku" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Test with advanced SKU object
    dev_center_dev_box_definitions = {
      advanced_sku = {
        name = "test-advanced-sku"
        dev_center = {
          key = "devcenter1"
        }
        resource_group = {
          key = "rg1"
        }
        image_reference_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.Compute/galleries/testgallery/images/testimage/versions/latest"
        sku = {
          name = "general_i_32c128gb1024ssd_v2"
          tier = "Standard"
        }
        hibernate_support = true
        tags = {
          test_case = "advanced_sku"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_dev_box_definitions["advanced_sku"] != null
    error_message = "DevBox Definition with advanced SKU should be planned for creation"
  }
}

// Test naming convention
run "test_naming_convention" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Test naming convention with different global settings
    global_settings = {
      prefixes      = ["prod"]
      random_length = 5
      passthrough   = false
      use_slug      = true
    }

    dev_center_dev_box_definitions = {
      naming_test = {
        name = "naming-convention-test"
        dev_center = {
          key = "devcenter1"
        }
        resource_group = {
          key = "rg1"
        }
        image_reference_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.Compute/galleries/testgallery/images/testimage/versions/latest"
        sku_name           = "general_i_8c32gb256ssd_v2"
        hibernate_support  = false
        tags = {
          test_case = "naming_convention"
        }
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = module.dev_center_dev_box_definitions["naming_test"] != null
    error_message = "DevBox Definition should be planned for creation with proper naming"
  }
}

// Test validation - multiple definitions with different configurations
run "test_multiple_definitions" {
  command = plan

  providers = {
    azapi    = azapi
    azurecaf = azurecaf
  }

  variables {
    // Test with multiple definitions
    dev_center_dev_box_definitions = {
      def1 = {
        name = "multi-test-1"
        dev_center = {
          key = "devcenter1"
        }
        resource_group = {
          key = "rg1"
        }
        image_reference_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.Compute/galleries/testgallery/images/testimage/versions/latest"
        sku_name           = "general_i_8c32gb256ssd_v2"
        hibernate_support  = true
      }
      def2 = {
        name = "multi-test-2"
        dev_center = {
          key = "devcenter1"
        }
        resource_group = {
          key = "rg1"
        }
        image_reference = {
          id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/test-rg/providers/Microsoft.Compute/galleries/testgallery/images/testimage2/versions/1.0.0"
        }
        sku = {
          name = "general_i_16c64gb512ssd_v2"
          tier = "Standard"
        }
        os_storage_type   = "ssd_512gb"
        hibernate_support = false
      }
    }
  }

  module { source = "../../../" }

  assert {
    condition     = length(keys(module.dev_center_dev_box_definitions)) == 2
    error_message = "Should have exactly two DevBox definitions"
  }

  assert {
    condition     = module.dev_center_dev_box_definitions["def1"] != null
    error_message = "First DevBox definition should be created"
  }

  assert {
    condition     = module.dev_center_dev_box_definitions["def2"] != null
    error_message = "Second DevBox definition should be created"
  }
}
