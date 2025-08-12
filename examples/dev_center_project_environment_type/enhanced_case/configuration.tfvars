global_settings = {
  prefixes      = ["enterprise"]
  random_length = 5
  passthrough   = false
  use_slug      = true
  regions = {
    primary = "eastus"
  }
  tags = {
    business_unit = "engineering"
    cost_center   = "development"
    project       = "devcenter-platform"
    owner         = "platform-team"
  }
}

resource_groups = {
  rg_devcenter = {
    name   = "devcenter-platform"
    region = "eastus"
    tags = {
      purpose = "devcenter_infrastructure"
    }
  }
  rg_deployment = {
    name   = "devcenter-deployments"
    region = "eastus"
    tags = {
      purpose = "deployment_target"
    }
  }
}

dev_centers = {
  enterprise_dc = {
    name = "enterprise-devcenter"
    resource_group = {
      key = "rg_devcenter"
    }
    dev_box_provisioning_settings = {
      install_azure_monitor_agent_enable_installation = "Enabled"
    }
    microsoft_hosted_network_enable_status = "Enabled"
    catalog_item_sync_enable_status        = "Enabled"
    tags = {
      environment     = "production"
      module          = "dev_center"
      tier            = "enterprise"
      monitoring      = "enabled"
      backup_required = "true"
    }
  }
}

dev_center_environment_types = {
  development = {
    name         = "development"
    display_name = "Development Environment Type"
    dev_center = {
      key = "enterprise_dc"
    }
    tags = {
      environment = "production"
      module      = "dev_center_environment_type"
      purpose     = "development"
      tier        = "standard"
    }
  }
  staging = {
    name         = "staging"
    display_name = "Staging Environment Type"
    dev_center = {
      key = "enterprise_dc"
    }
    tags = {
      environment = "production"
      module      = "dev_center_environment_type"
      purpose     = "staging"
      tier        = "premium"
    }
  }
  production = {
    name         = "production"
    display_name = "Production Environment Type"
    dev_center = {
      key = "enterprise_dc"
    }
    tags = {
      environment     = "production"
      module          = "dev_center_environment_type"
      purpose         = "production"
      tier            = "premium"
      criticality     = "high"
      backup_required = "true"
    }
  }
}

dev_center_projects = {
  web_team_project = {
    name                       = "web-applications"
    description                = "Project for web application development teams"
    display_name               = "Web Applications Project"
    maximum_dev_boxes_per_user = 3
    dev_center = {
      key = "enterprise_dc"
    }
    resource_group = {
      key = "rg_devcenter"
    }
    identity = {
      type = "SystemAssigned"
    }
    azure_ai_services_settings = {
      azure_ai_services_mode = "AutoDeploy"
    }
    catalog_settings = {
      catalog_item_sync_types = ["EnvironmentDefinition", "ImageDefinition"]
    }
    customization_settings = {
      user_customizations_enable_status = "Enabled"
    }
    dev_box_auto_delete_settings = {
      delete_mode        = "Auto"
      grace_period       = "PT4H"    # 4 hours
      inactive_threshold = "PT24H"   # 24 hours
    }
    tags = {
      environment = "production"
      module      = "dev_center_project"
      team        = "web_development"
      tier        = "premium"
    }
  }
  api_team_project = {
    name                       = "api-services"
    description                = "Project for API and backend service development"
    display_name               = "API Services Project"
    maximum_dev_boxes_per_user = 5
    dev_center = {
      key = "enterprise_dc"
    }
    resource_group = {
      key = "rg_devcenter"
    }
    identity = {
      type = "SystemAssigned"
    }
    serverless_gpu_sessions_settings = {
      max_concurrent_sessions_per_project = 10
      serverless_gpu_sessions_mode        = "AutoDeploy"
    }
    workspace_storage_settings = {
      workspace_storage_mode = "AutoDeploy"
    }
    tags = {
      environment = "production"
      module      = "dev_center_project"
      team        = "api_development"
      tier        = "premium"
    }
  }
}

dev_center_project_environment_types = {
  web_dev_env = {
    name                  = "web-development"
    environment_type_name = "development"
    deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/devcenter-deployments"
    dev_center_project = {
      key = "web_team_project"
    }
    creator_role_assignment = {
      roles = ["Contributor", "User Access Administrator"]
    }
    user_role_assignments = [
      {
        roles   = ["Reader", "Web Plan Contributor"]
        user_id = "web-developers@company.com"
      },
      {
        roles   = ["Contributor"]
        user_id = "web-team-leads@company.com"
      }
    ]
    tags = {
      environment = "production"
      module      = "dev_center_project_environment_type"
      team        = "web_development"
      purpose     = "development"
      tier        = "standard"
    }
  }
  web_staging_env = {
    name                  = "web-staging"
    environment_type_name = "staging"
    deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/devcenter-deployments"
    dev_center_project = {
      key = "web_team_project"
    }
    creator_role_assignment = {
      roles = ["Contributor"]
    }
    user_role_assignments = [
      {
        roles   = ["Reader"]
        user_id = "web-developers@company.com"
      },
      {
        roles   = ["Contributor", "User Access Administrator"]
        user_id = "web-team-leads@company.com"
      }
    ]
    tags = {
      environment = "production"
      module      = "dev_center_project_environment_type"
      team        = "web_development"
      purpose     = "staging"
      tier        = "premium"
    }
  }
  api_dev_env = {
    name                  = "api-development"
    environment_type_name = "development"
    deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/devcenter-deployments"
    dev_center_project = {
      key = "api_team_project"
    }
    creator_role_assignment = {
      roles = ["Contributor", "Storage Account Contributor"]
    }
    user_role_assignments = [
      {
        roles   = ["Reader", "API Management Service Reader"]
        user_id = "api-developers@company.com"
      },
      {
        roles   = ["Contributor", "User Access Administrator"]
        user_id = "api-team-leads@company.com"
      }
    ]
    tags = {
      environment = "production"
      module      = "dev_center_project_environment_type"
      team        = "api_development"
      purpose     = "development"
      tier        = "standard"
    }
  }
  api_production_env = {
    name                  = "api-production"
    environment_type_name = "production"
    deployment_target_id  = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/devcenter-deployments"
    dev_center_project = {
      key = "api_team_project"
    }
    creator_role_assignment = {
      roles = ["Reader"]
    }
    user_role_assignments = [
      {
        roles   = ["Reader"]
        user_id = "api-developers@company.com"
      },
      {
        roles   = ["Contributor"]
        user_id = "api-team-leads@company.com"
      },
      {
        roles   = ["Owner"]
        user_id = "platform-administrators@company.com"
      }
    ]
    tags = {
      environment     = "production"
      module          = "dev_center_project_environment_type"
      team            = "api_development"
      purpose         = "production"
      tier            = "premium"
      criticality     = "high"
      backup_required = "true"
      audit_required  = "true"
    }
  }
}