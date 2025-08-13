global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
  tags = {
    environment = "demo"
    project     = "devfactory"
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
    identity = {
      type = "SystemAssigned"
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
  staging = {
    name         = "staging"
    display_name = "Staging Environment Type"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      environment = "demo"
      module      = "dev_center_environment_type"
      purpose     = "staging"
    }
  }
}

dev_center_projects = {
  project1 = {
    name = "devproject"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    description                = "Development project for the engineering team"
    display_name               = "Engineering Development Project"
    maximum_dev_boxes_per_user = 3

    # Identity configuration
    identity = {
      type = "SystemAssigned"
    }

    tags = {
      environment = "demo"
      module      = "dev_center_project"
      cost_center = "engineering"
    }
  }
}

dev_center_project_environment_types = {
  projenvtype1 = {
    name = "dev-environment"
    project = {
      key = "project1"
    }
    # Use the resource group as the deployment target for this example
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/devfactory-dc-dev-123"
    status = "Enabled"
    
    creator_role_assignment = {
      roles = [
        "b24988ac-6180-42a0-ab88-20f7382dd24c" # Contributor
      ]
    }
    
    user_role_assignments = {
      "development-team" = {
        roles = [
          "acdd72a7-3385-48ef-bd42-f606fba81ae7" # Reader
        ]
      }
    }
    
    tags = {
      environment = "demo"
      module      = "dev_center_project_environment_type"
      purpose     = "development"
    }
  }
  
  projenvtype2 = {
    name = "staging-environment"
    project = {
      key = "project1"
    }
    # Use the resource group as the deployment target for this example
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/devfactory-dc-dev-123"
    status = "Enabled"
    
    tags = {
      environment = "demo"
      module      = "dev_center_project_environment_type"
      purpose     = "staging"
    }
  }
}