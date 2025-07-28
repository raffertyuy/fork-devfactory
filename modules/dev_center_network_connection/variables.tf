variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = optional(list(string))
    random_length = optional(number)
    passthrough   = optional(bool)
    use_slug      = optional(bool)
    tags          = optional(map(string))
  })
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Dev Center Network Connection"
  type        = string
}

variable "location" {
  description = "The location/region where the Dev Center Network Connection is created"
  type        = string
}

variable "dev_center_network_connection" {
  description = "Configuration object for the Dev Center Network Connection"
  type = object({
    name              = string
    domain_join_type  = string
    subnet_id         = string
    domain_name       = optional(string)
    domain_password   = optional(string)
    domain_username   = optional(string)
    organization_unit = optional(string)
    tags              = optional(map(string))
  })

  validation {
    condition     = contains(["AzureADJoin", "HybridAzureADJoin"], var.dev_center_network_connection.domain_join_type)
    error_message = "Domain join type must be either 'AzureADJoin' or 'HybridAzureADJoin'."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]$", var.dev_center_network_connection.name)) && length(var.dev_center_network_connection.name) >= 3 && length(var.dev_center_network_connection.name) <= 63
    error_message = "Dev Center Network Connection name must be between 3 and 63 characters long and can contain alphanumeric characters, periods, hyphens, and underscores. It must start and end with an alphanumeric character."
  }
}