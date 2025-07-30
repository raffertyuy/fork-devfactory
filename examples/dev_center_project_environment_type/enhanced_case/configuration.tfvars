global_settings = {
  prefixes      = ["corp"]
  random_length = 3
  tags = {
    environment = "production"
    workload    = "devcenter"
    owner       = "platform-team"
  }
}

resource_groups = {
  devcenter_rg = {
    name   = "devcenter-resources"
    region = "eastus"
  }
}

dev_centers = {
  corp = {
    name           = "corp-devcenter"
    resource_group = { key = "devcenter_rg" }
  }
}

dev_center_environment_types = {
  dev = {
    name       = "development"
    dev_center = { key = "corp" }
  }
  staging = {
    name       = "staging"
    dev_center = { key = "corp" }
  }
  prod = {
    name       = "production"
    dev_center = { key = "corp" }
  }
}

dev_center_projects = {
  webapp = {
    name           = "webapp-project"
    dev_center     = { key = "corp" }
    resource_group = { key = "devcenter_rg" }
  }
  api = {
    name           = "api-project"
    dev_center     = { key = "corp" }
    resource_group = { key = "devcenter_rg" }
  }
}

dev_center_project_environment_types = {
  webapp_dev = {
    name                 = "development"
    project              = { key = "webapp" }
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
    status               = "Enabled"
    display_name         = "Web App Development Environment"
    creator_role_assignment = {
      roles = {
        "b24988ac-6180-42a0-ab88-20f7382dd24c" = {} # Contributor
      }
    }
    user_role_assignments = {
      "11111111-1111-1111-1111-111111111111" = {
        roles = {
          "acdd72a7-3385-48ef-bd42-f606fba81ae7" = {} # Reader
        }
      }
    }
    tags = {
      purpose = "web-development"
    }
  }
  webapp_staging = {
    name                 = "staging"
    project              = { key = "webapp" }
    deployment_target_id = "/subscriptions/87654321-4321-4321-4321-210987654321"
    status               = "Enabled"
    display_name         = "Web App Staging Environment"
  }
  api_dev = {
    name                 = "development"
    project              = { key = "api" }
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
    status               = "Enabled"
    display_name         = "API Development Environment"
    identity = {
      type = "SystemAssigned"
    }
  }
  api_prod = {
    name                 = "production"
    project              = { key = "api" }
    deployment_target_id = "/subscriptions/11111111-2222-3333-4444-555555555555"
    status               = "Disabled" # Initially disabled for approval workflow
    display_name         = "API Production Environment"
  }
}
