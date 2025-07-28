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
    name     = "example-dev-center-network-connection"
    location = "West Europe"
    tags = {
      Purpose = "DevCenter Network Connection Demo"
    }
  }
}

# Virtual Network Configuration
virtual_networks = {
  "dev_center_vnet" = {
    name          = "example-dev-center-vnet"
    location      = "West Europe"
    address_space = ["10.0.0.0/16"]
  }
}

# Subnet Configuration
subnets = {
  "dev_center_subnet" = {
    name                 = "dev-center-subnet"
    address_prefixes     = ["10.0.1.0/24"]
    virtual_network_name = "example-dev-center-vnet"
  }
}

# Dev Center Network Connection Configuration
dev_center_network_connections = {
  "example_connection" = {
    name             = "example-network-connection"
    domain_join_type = "AzureADJoin"
    # subnet_id will be populated at runtime
    tags = {
      Purpose = "Development Environment"
    }
  }
}