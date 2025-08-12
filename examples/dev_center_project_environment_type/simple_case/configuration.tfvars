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
    name   = "devfactory-dc"
    region = "eastus"
  }
}

dev_centers = {
  devcenter1 = {
    name = "devcenter"
    resource_group = {
      key = "rg1"
    }
    tags = {
      environment = "demo"
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
      environment = "demo"
      module      = "dev_center_environment_type"
      purpose     = "development"
    }
  }
}

dev_center_projects = {
  project1 = {
    name        = "devproject"
    description = "Development project for testing environment types"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    tags = {
      environment = "demo"
      module      = "dev_center_project"
      purpose     = "development"
    }
  }
}

dev_center_project_environment_types = {
  projenvtype1 = {
    name                  = "terraform-env"
    environment_type_name = "development"
    deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/devfactory-dc"
    dev_center_project = {
      key = "project1"
    }
    tags = {
      environment = "demo"
      module      = "dev_center_project_environment_type"
      purpose     = "development"
    }
  }
}