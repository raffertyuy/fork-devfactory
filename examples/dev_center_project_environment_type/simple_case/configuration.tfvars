global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
  tags = {
    environment = "demo"
    created_by  = "terraform"
  }
}

resource_groups = {
  rg1 = {
    name   = "devfactory-pet"
    region = "eastus"
  }
}

dev_centers = {
  devcenter1 = {
    name = "pet-devcenter"
    resource_group = {
      key = "rg1"
    }
    identity = {
      type = "SystemAssigned"
    }
  }
}

dev_center_environment_types = {
  envtype1 = {
    name         = "development"
    display_name = "Development Environment Type"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      purpose = "development"
      team    = "engineering"
    }
  }
}

dev_center_projects = {
  project1 = {
    name = "pet-project"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    description                = "Project for environment type linking"
    maximum_dev_boxes_per_user = 2

    tags = {
      module = "dev_center_project"
      tier   = "basic"
    }
  }
}

dev_center_project_environment_types = {
  projenvtype1 = {
    name                 = "development"
    display_name         = "Development Environment"
    status               = "Enabled"
    deployment_target_id = "/subscriptions/SUBSCRIPTION_ID"
    project = {
      key = "project1"
    }
    resource_group = {
      key = "rg1"
    }
    tags = {
      environment = "demo"
      module      = "dev_center_project_environment_type"
    }

    creator_role_assignment = {
      roles = {
        owner = {
          role_definition_id = "/subscriptions/SUBSCRIPTION_ID/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
        }
      }
    }
  }
}