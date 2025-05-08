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

# Example of a simple catalog attached to a dev center
dev_center_catalogs = {
  catalog1 = {
    name = "default-catalog"
    dev_center = {
      key = "devcenter1"
    }
    catalog = {
      name = "default-catalog"
    }
    tags = {
      environment = "demo"
    }
  }
}

# Example of a catalog integrated with GitHub
dev_center_catalogs_github = {
  catalog_github = {
    name = "github-catalog"
    dev_center = {
      key = "devcenter1"
    }
    catalog = {
      name = "github-catalog",
      catalog_github = {
        uri               = "https://github.com/contoso/catalog-repo"
        branch            = "main"
        path              = "/catalog-items"
        # In a real environment, use Azure Key Vault for storing the secret
        key_vault_key_url = "https://keyvault.vault.azure.net/secrets/github-token"
      }
    }
    tags = {
      environment = "demo"
      source      = "github"
    }
  }
}

# Example of a catalog integrated with Azure DevOps
dev_center_catalogs_ado = {
  catalog_adogit = {
    name = "ado-catalog"
    dev_center = {
      key = "devcenter1"
    }
    catalog = {
      name = "ado-catalog",
      catalog_adogit = {
        uri               = "https://dev.azure.com/contoso/project/_git/catalog-repo"
        branch            = "main"
        path              = "/catalog-items"
        # In a real environment, use Azure Key Vault for storing the secret
        key_vault_key_url = "https://keyvault.vault.azure.net/secrets/ado-token"
      }
    }
    tags = {
      environment = "demo"
      source      = "ado"
    }
  }
}