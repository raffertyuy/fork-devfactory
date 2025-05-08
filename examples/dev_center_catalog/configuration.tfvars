global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
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
    }
  }
}

dev_center_catalogs = {
  catalog1 = {
    name = "github-catalog"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    catalog_git = {
      # Only one of the following is required
      catalog_github = {
        uri               = "https://github.com/contoso/catalog-repo"
        branch            = "" # leave blank if default branch
        path              = "catalog-items"
        key_vault_key_url = "" # leave blank if public repo
      }
      catalog_adogit = {
        uri               = "https://dev.azure.com/contoso/project/_git/catalog-repo"
        branch            = "" # leave blank if default branch
        path              = "catalog-items"
        key_vault_key_url = "" # leave blank if public repo
      }
    }
  }
}