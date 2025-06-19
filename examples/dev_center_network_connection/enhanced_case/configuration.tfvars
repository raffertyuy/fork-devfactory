global_settings = {
  prefixes      = ["corp"]
  random_length = 8
  passthrough   = false
  use_slug      = true
  tags = {
    Project     = "DevFactory"
    Environment = "Production"
    CostCenter  = "IT-Infrastructure"
    Owner       = "IT-Team"
  }
}

# Resource Group Configuration
resource_groups = {
  "dev_center_network_connection" = {
    name     = "enhanced-dev-center-network-connection"
    location = "East US 2"
    tags = {
      Purpose = "DevCenter Network Connection Enhanced Demo"
      Tier    = "Production"
    }
  }
}

# Virtual Network Configuration
virtual_networks = {
  "dev_center_vnet" = {
    name          = "enhanced-dev-center-vnet"
    location      = "East US 2"
    address_space = ["172.16.0.0/16"]
  }
}

# Subnet Configuration
subnets = {
  "dev_center_subnet" = {
    name             = "dev-center-hybrid-subnet"
    address_prefixes = ["172.16.10.0/24"]
    virtual_network_name = "enhanced-dev-center-vnet"
  }
}

# Dev Center Network Connection Configuration - Hybrid Azure AD Join
dev_center_network_connections = {
  "enhanced_hybrid_connection" = {
    name              = "enhanced-hybrid-network-connection"
    domain_join_type  = "HybridAzureADJoin"
    # subnet_id will be populated at runtime
    domain_name       = "corp.contoso.local"
    domain_username   = "svc-devcenter@corp.contoso.local"
    # Note: In production, use Azure Key Vault for sensitive data
    domain_password   = var.domain_password  # Pass via environment variable
    organization_unit = "OU=DevBoxes,OU=Computers,DC=corp,DC=contoso,DC=local"
    tags = {
      Purpose     = "Production Development Environment"
      DomainJoin  = "Hybrid"
      Compliance  = "Required"
    }
  }
}