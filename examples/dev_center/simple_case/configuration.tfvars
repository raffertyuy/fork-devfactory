global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
}

resource_groups = {
  rg1 = {
    name   = "devfactory-dc"
    region = "australiaeast"
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

dev_center_catalogs = {
  catalog1 = {
    name = "task-catalog"
    dev_center = {
      key = "devcenter1"
    }
    resource_group = {
      key = "rg1"
    }
    catalog_git = {
      catalog_github = {
        uri    = "https://github.com/0GiS0/azure-dev-center-demos"
        branch = ""
        path   = "allowed-tasks"
        #key_vault_key_url = "https://keyvault.vault.azure.net/secrets/github-token"
        #key_vault_key_url = "https://raz-vault.vault.azure.net/secrets/githubpat/84b3758f3ada4108a3697c805949029a"
        key_vault_key_url = ""
      }
    }
  }
}