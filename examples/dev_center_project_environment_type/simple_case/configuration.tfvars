global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
}

resource_groups = {
  rg1 = {
    name   = "devfactory-dc-pet"
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
    name        = "project1"
    description = "Demo Project for Environment Types"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    tags = {
      environment = "demo"
      module      = "dev_center_project"
    }
  }
}

dev_center_project_environment_types = {
  projenvtype1 = {
    name                 = "development"
    display_name         = "Project Development Environment"
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
    project = {
      key = "project1"
    }
    environment_type = {
      key = "development"
    }
    tags = {
      environment = "demo"
      module      = "dev_center_project_environment_type"
    }
  }
}