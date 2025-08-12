global_settings = {
  prefixes      = ["myorg", "dev"]
  random_length = 5
  passthrough   = false
  use_slug      = true
  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
    CostCenter  = "Engineering"
  }
}

resource_groups = {
  rg1 = {
    name   = "devfactory-dc-enhanced"
    region = "eastus"
  }
}

dev_centers = {
  devcenter1 = {
    name        = "devcenter-enhanced"
    description = "Enhanced Dev Center for multiple environment types"
    resource_group = {
      key = "rg1"
    }
    tags = {
      tier        = "production"
      module      = "dev_center"
      criticality = "high"
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
      purpose     = "development"
      auto_deploy = "enabled"
    }
  }
  staging = {
    name         = "staging"
    display_name = "Staging Environment Type"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      purpose     = "testing"
      auto_deploy = "enabled"
    }
  }
  production = {
    name         = "production"
    display_name = "Production Environment Type"
    dev_center = {
      key = "devcenter1"
    }
    tags = {
      purpose     = "production"
      auto_deploy = "disabled"
      criticality = "high"
    }
  }
}

dev_center_projects = {
  frontend_project = {
    name        = "frontend-app"
    description = "Frontend Application Project"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    tags = {
      team        = "frontend"
      application = "web-portal"
    }
  }
  backend_project = {
    name        = "backend-api"
    description = "Backend API Project"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    tags = {
      team        = "backend"
      application = "api-service"
    }
  }
}

dev_center_project_environment_types = {
  frontend_dev = {
    status               = "Enabled"
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
    project = {
      key = "frontend_project"
    }
    environment_type = {
      key = "development"
    }
    creator_role_assignment = {
      roles = ["Contributor", "DevCenter Dev Box User"]
    }
    tags = {
      team = "frontend"
      tier = "development"
    }
  }
  frontend_staging = {
    status               = "Enabled"
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
    project = {
      key = "frontend_project"
    }
    environment_type = {
      key = "staging"
    }
    creator_role_assignment = {
      roles = ["Contributor"]
    }
    tags = {
      team = "frontend"
      tier = "staging"
    }
  }
  backend_dev = {
    status               = "Enabled"
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/backend-dev-rg"
    project = {
      key = "backend_project"
    }
    environment_type = {
      key = "development"
    }
    creator_role_assignment = {
      roles = ["Contributor", "Storage Blob Data Contributor"]
    }
    tags = {
      team = "backend"
      tier = "development"
    }
  }
  backend_production = {
    status               = "Disabled"  # Disabled by default, enable when ready
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/backend-prod-rg"
    project = {
      key = "backend_project"
    }
    environment_type = {
      key = "production"
    }
    creator_role_assignment = {
      roles = ["Reader"]  # Limited permissions for production
    }
    tags = {
      team        = "backend"
      tier        = "production"
      criticality = "high"
    }
  }
}