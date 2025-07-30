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
    name   = "enhanced-dev-center-network-connection"
    region = "eastus"
    tags = {
      Purpose = "DevCenter Network Connection Enhanced Demo"
      Tier    = "Production"
    }
  }
}

# Dev Center Network Connection Configuration - Hybrid Azure AD Join
dev_center_network_connections = {
  "enhanced_hybrid_connection" = {
    name             = "enhanced-hybrid-network-connection"
    domain_join_type = "HybridAzureADJoin"
    subnet_id        = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-alz-connectivity/providers/Microsoft.Network/virtualNetworks/alz-hub-eastus2/subnets/Sandbox"
    resource_group = {
      key = "dev_center_network_connection"
    }
    domain_join = {
      domain_name              = "corp.contoso.local"
      domain_username          = "svc-devcenter@corp.contoso.local"
      organizational_unit_path = "OU=DevBoxes,OU=Computers,DC=corp,DC=contoso,DC=local"
      # Note: In production, use Azure Key Vault for domain_password_secret_id
      # domain_password_secret_id = "/subscriptions/.../vaults/vault/secrets/domain-password"
    }
    tags = {
      Purpose    = "Production Development Environment"
      DomainJoin = "Hybrid"
      Compliance = "Required"
    }
  }
}