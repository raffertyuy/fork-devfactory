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
    }))

    # SKU configuration - supports both simple name and full object
    sku_name = optional(string)
    sku = optional(object({
      name     = string           # Required: The name of the SKU
      capacity = optional(number) # Optional: Integer for scale out/in support
      family   = optional(string) # Optional: Hardware generation
      size     = optional(string) # Optional: Standalone SKU size code
      tier     = optional(string) # Optional: Free, Basic, Standard, Premium
    }))

    # OS Storage type for the Operating System disk
    os_storage_type = optional(string)

    # Hibernate support - simplified boolean (maps to "Enabled"/"Disabled" in API)
    hibernate_support = optional(bool, false)

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
    condition = (
      var.dev_box_definition.sku_name != null ||
      var.dev_box_definition.sku != null
    )
    error_message = "Either sku_name or sku must be specified."
  }

  validation {
    condition = (
      var.dev_box_definition.sku == null ||
      var.dev_box_definition.sku.name != null
    )
    error_message = "When using sku object, the 'name' field is required."
  }

  validation {
    condition = (
      var.dev_box_definition.sku == null ||
      var.dev_box_definition.sku.tier == null ||
      contains(["Free", "Basic", "Standard", "Premium"], var.dev_box_definition.sku.tier)
    )
    error_message = "SKU tier must be one of: Free, Basic, Standard, Premium."
  }

  validation {
    condition = (
      var.dev_box_definition.sku == null ||
      var.dev_box_definition.sku.capacity == null ||
      var.dev_box_definition.sku.capacity >= 1
    )
    error_message = "SKU capacity must be a positive integer when specified."
  }

  validation {
    condition     = length(var.dev_box_definition.name) <= 63
    error_message = "DevBox Definition name must be 63 characters or less."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.dev_box_definition.name))
    error_message = "DevBox Definition name must start and end with alphanumeric characters and can contain hyphens."
  }

  validation {
    condition = (
      var.dev_box_definition.os_storage_type == null ||
      can(regex("^(ssd|premium)_(128|256|512|1024)gb$", var.dev_box_definition.os_storage_type))
    )
    error_message = "OS storage type must follow the pattern: (ssd|premium)_(128|256|512|1024)gb (e.g., 'ssd_256gb', 'premium_512gb')."
  }
}

variable "tags" {
  description = "Additional tags to apply to the DevBox Definition"
  type        = map(string)
  default     = {}
}
