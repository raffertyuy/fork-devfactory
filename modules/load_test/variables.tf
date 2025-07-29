variable "load_test" {
  description = "Configuration object for the Azure Load Test resource"
  type = object({
    name        = string
    description = optional(string)
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string))
    }))
    encryption = optional(object({
      identity = optional(object({
        type        = string
        resource_id = optional(string)
      }))
      key_url = optional(string)
    }))
    tags = optional(map(string), {})
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9_-]{0,62}[a-zA-Z0-9]$", var.load_test.name))
    error_message = "Load test name must be 2-64 characters, start and end with alphanumeric, contain only alphanumeric, underscores, and hyphens."
  }

  validation {
    condition     = var.load_test.description == null || can(regex("^.{0,512}$", var.load_test.description))
    error_message = "Load test description must be 512 characters or less."
  }

  validation {
    condition     = var.load_test.identity == null || contains(["None", "SystemAssigned", "UserAssigned", "SystemAssigned,UserAssigned"], var.load_test.identity.type)
    error_message = "Identity type must be one of: None, SystemAssigned, UserAssigned, SystemAssigned,UserAssigned."
  }

  validation {
    condition     = var.load_test.encryption == null || var.load_test.encryption.identity == null || contains(["SystemAssigned", "UserAssigned"], var.load_test.encryption.identity.type)
    error_message = "Encryption identity type must be either SystemAssigned or UserAssigned."
  }
}

variable "location" {
  description = "The Azure region where the load test resource will be created"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "The name of the resource group where the load test will be created"
  type        = string
}

variable "global_settings" {
  description = "Global settings for resource naming and tagging"
  type = object({
    prefixes      = optional(list(string), [])
    suffixes      = optional(list(string), [])
    random_length = optional(number, 0)
    passthrough   = optional(bool, false)
    use_slug      = optional(bool, true)
    separator     = optional(string, "-")
    tags          = optional(map(string), {})
  })
  default = {
    prefixes      = []
    suffixes      = []
    random_length = 0
    passthrough   = false
    use_slug      = true
    separator     = "-"
    tags          = {}
  }
}
