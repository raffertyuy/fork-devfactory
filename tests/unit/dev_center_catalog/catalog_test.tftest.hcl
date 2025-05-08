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

  dev_center_catalogs = {
    catalog1 = {
      name = "test-catalog"
      dev_center = {
        key = "devcenter1"
      }
      resource_group = {
        key = "rg1"
      }
      tags = {
        environment = "test"
        module      = "dev_center_catalog"
      }
    }
  }

  // Empty variables required by the root module
  dev_center_galleries                 = {}
  dev_center_dev_box_definitions       = {}
  dev_center_projects                  = {}
  dev_center_environment_types         = {}
  dev_center_project_environment_types = {}
  dev_center_network_connections       = {}
  shared_image_galleries               = {}
}

mock_provider "azurerm" {}

run "catalog_creation" {
  command = plan

  module {
    source = "../../../"
  }

  assert {
    condition     = module.dev_center_catalogs["catalog1"].name != ""
    error_message = "Catalog name should not be empty"
  }
}
