global_settings = {
  prefixes      = ["dev"]
  random_length = 3
  passthrough   = false
  use_slug      = true
  environment   = "demo"
  regions = {
    region1 = "eastus"
  }
}

resource_groups = {
  rg1 = {
    name   = "devfactory-demo-rg"
    region = "region1"
    tags = {
      environment = "demo"
    }
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
    support_info = {
      email = "admin@contoso.com"
      url   = "https://support.contoso.com"
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
    git_hub = {
      uri    = "https://github.com/contoso/catalog-repo"
      branch = "main"
      path   = "/catalog-items"
      # Note: In a real environment, use Azure Key Vault for storing the secret
      # secret_identifier = "https://keyvault.vault.azure.net/secrets/github-token"
    }
    sync_type = "Scheduled"
    tags = {
      environment = "demo"
      source      = "github"
    }
  }
}

# Example of a catalog integrated with Azure DevOps
dev_center_catalogs_ado = {
  catalog_ado = {
    name = "ado-catalog"
    dev_center = {
      key = "devcenter1"
    }
    ado_git = {
      uri    = "https://dev.azure.com/contoso/project/_git/catalog-repo"
      branch = "main"
      path   = "/catalog-items"
      # Note: In a real environment, use Azure Key Vault for storing the secret
      # secret_identifier = "https://keyvault.vault.azure.net/secrets/ado-token"
    }
    sync_type = "Manual"
    tags = {
      environment = "demo"
      source      = "ado"
    }
  }
}
