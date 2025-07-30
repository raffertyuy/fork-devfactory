global_settings = {
  prefixes      = ["demo"]
  random_length = 3
  tags = {
    environment = "development"
    workload    = "devcenter"
  }
}

resource_groups = {
  devcenter_rg = {
    name   = "devcenter-resources"
    region = "eastus"
  }
}

dev_centers = {
  main = {
    name           = "demo-devcenter"
    resource_group = { key = "devcenter_rg" }
  }
}

dev_center_environment_types = {
  dev = {
    name       = "development"
    dev_center = { key = "main" }
  }
}

dev_center_projects = {
  webapp = {
    name           = "webapp-project"
    dev_center     = { key = "main" }
    resource_group = { key = "devcenter_rg" }
  }
}

dev_center_project_environment_types = {
  webapp_dev = {
    name                 = "demo-dcet-development-jsm"
    project              = { key = "webapp" }
    deployment_target_id = "/subscriptions/12345678-1234-1234-1234-123456789012"
    status               = "Enabled"
  }
}
