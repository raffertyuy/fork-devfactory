variable "global_settings" {
  description = "Global settings object for naming conventions and standard parameters"
  type = object({
    prefixes      = list(string)
    random_length = number
    passthrough   = bool
    use_slug      = bool
    tags          = optional(map(string), {})
  })
}

variable "location" {
  description = "The Azure region where the DevBox Definition will be created"
  type        = string
}

variable "dev_center_id" {
  description = "The ID of the Dev Center where the DevBox Definition will be created"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[^/]+/resourceGroups/[^/]+/providers/Microsoft.DevCenter/devcenters/[^/]+$", var.dev_center_id))
    error_message = "The dev_center_id must be a valid Azure Dev Center resource ID."
  }
}

variable "dev_box_definition" {
  description = "Configuration object for the DevBox Definition"
  type = object({
    name = string

    # Image reference - supports both direct ID and object form
    image_reference_id = optional(string)
    image_reference = optional(object({
      id = string
    })) # SKU configuration - storage is defined within the SKU name itself
    sku_name = string

    # Hibernate support
    hibernate_support = optional(object({
      enabled = optional(bool, false)
    }))

    # Tags
    tags = optional(map(string), {})
  })

  validation {
    condition = (
      var.dev_box_definition.image_reference_id != null ||
      var.dev_box_definition.image_reference != null
    )
    error_message = "Either image_reference_id or image_reference must be specified."
  }


  validation {
    condition     = length(var.dev_box_definition.name) <= 63
    error_message = "DevBox Definition name must be 63 characters or less."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.dev_box_definition.name))
    error_message = "DevBox Definition name must start and end with alphanumeric characters and can contain hyphens."
  }
}

variable "tags" {
  description = "Additional tags to apply to the DevBox Definition"
  type        = map(string)
  default     = {}
}
