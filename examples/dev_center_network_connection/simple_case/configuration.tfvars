global_settings = {
  prefixes      = ["example"]
  random_length = 5
  passthrough   = false
  use_slug      = true
  tags = {
    Project     = "DevFactory"
    Environment = "Development"
  }
}

# Resource Group Configuration
resource_groups = {
  "dev_center_network_connection" = {
    name   = "example-dev-center-network-connection"
    region = "eastus"
    tags = {
      Purpose = "DevCenter Network Connection Demo"
    }
  }
}

# Dev Center Network Connection Configuration
dev_center_network_connections = {
  "example_connection" = {
    name             = "example-network-connection"
    domain_join_type = "AzureADJoin"
    subnet_id        = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-alz-connectivity/providers/Microsoft.Network/virtualNetworks/alz-hub-eastus/subnets/Sandbox"
    resource_group = {
      key = "dev_center_network_connection"
    }
    tags = {
      Purpose = "Development Environment"
    }
  }
}