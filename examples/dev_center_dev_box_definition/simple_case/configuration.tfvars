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
    name   = "devfactory-devbox"
    region = "eastus"
  }
}

dev_centers = {
  devcenter1 = {
    name = "simple-devcenter"
    resource_group = {
      key = "rg1"
    }
    identity = {
      type = "SystemAssigned"
    }
  }
}

dev_center_dev_box_definitions = {
  win11_dev = {
    name = "win11-dev"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    # Using DevCenter built-in image reference (relative to dev center)
    image_reference_id = "galleries/default/images/microsoftvisualstudio_visualstudioplustools_vs-2022-ent-general-win11-m365-gen2"
    sku_name           = "general_i_8c32gb256ssd_v2"

    hibernate_support = {
      enabled = false
    }

    tags = {
      module  = "dev_center_dev_box_definition"
      tier    = "basic"
      os_type = "windows"
      purpose = "development"
    }
  }
}
