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
    name             = string
    domain_join_type = string
    subnet_id        = string
    dev_center_id    = optional(string)
    dev_center = optional(object({
      key = string
    }))
    resource_group = optional(object({
      key = string
    }))
    domain_join = optional(object({
      domain_name               = string
      domain_password_secret_id = optional(string)
      domain_username           = string
      organizational_unit_path  = optional(string)
    }))
    networking_resource_group_name = optional(string)
    tags                           = optional(map(string), {})
  })

  validation {
    condition     = contains(["AzureADJoin", "HybridAzureADJoin", "None"], var.dev_center_network_connection.domain_join_type)
    error_message = "Domain join type must be one of: AzureADJoin, HybridAzureADJoin, None."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]$", var.dev_center_network_connection.name)) && length(var.dev_center_network_connection.name) >= 3 && length(var.dev_center_network_connection.name) <= 63
    error_message = "Dev Center Network Connection name must be between 3 and 63 characters long and can contain alphanumeric characters, periods, hyphens, and underscores. It must start and end with an alphanumeric character."
  }
}