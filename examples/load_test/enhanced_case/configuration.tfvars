global_settings = {
  prefixes = ["devfactory"]
  suffixes = ["prod", "001"]
  tags = {
    environment = "production"
    project     = "devfactory"
  }
}

resource_groups = {
  "loadtest_rg" = {
    name   = "loadtest-resources"
    region = "eastus"
  }
}

load_tests = {
  "enhanced_load_test" = {
    name               = "enhanced-load-test"
    resource_group_key = "loadtest_rg"
    description        = "Enhanced load testing service with identity and encryption"
    identity = {
      type = "SystemAssigned"
    }
    encryption = {
      identity = {
        type = "SystemAssigned"
      }
      key_url = "https://my-keyvault.vault.azure.net/keys/loadtest-key/version"
    }
    tags = {
      purpose     = "load-testing"
      environment = "production"
      encryption  = "enabled"
    }
  }
}
