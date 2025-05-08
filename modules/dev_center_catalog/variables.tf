variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = list(string)
    random_length = number
    passthrough   = bool
    use_slug      = bool
  })
  validation {
    condition = (
      length(var.global_settings.prefixes) > 0 &&
      var.global_settings.random_length >= 0
    )
    error_message = "global_settings must have valid prefixes and random_length >= 0."
  }
}

variable "dev_center_id" {
  description = "The ID of the Dev Center in which to create the catalog"
  type        = string
  validation {
    condition     = length(var.dev_center_id) > 0
    error_message = "dev_center_id must be a non-empty string."
  }
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Dev Center exists"
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "resource_group_name must be a non-empty string."
  }
}

variable "tags" {
  description = "Optional tags to apply to the catalog. Merged with global and resource-specific tags."
  type        = map(string)
  default     = {}
}

variable "catalog" {
  description = "Configuration object for the Dev Center Catalog"
  type = object({
    name        = string
    description = optional(string)
    git_hub = optional(object({
      uri               = string
      branch            = optional(string)
      path              = optional(string)
      secret_identifier = optional(string)
    }))
    ado_git = optional(object({
      uri               = string
      branch            = optional(string)
      path              = optional(string)
      secret_identifier = optional(string)
    }))
    catalog_github = optional(object({
      uri               = string
      branch            = string
      path              = string
      key_vault_key_url = string
    }))
    catalog_adogit = optional(object({
      uri               = string
      branch            = string
      path              = string
      key_vault_key_url = string
    }))
    sync_type = optional(string)
    tags      = optional(map(string))
  })
  validation {
    condition     = length(var.catalog.name) > 0
    error_message = "catalog.name must be a non-empty string."
  }

  # Validation to ensure only one source type is specified (if any)
  validation {
    condition = (
      sum([
        var.catalog.git_hub != null ? 1 : 0,
        var.catalog.ado_git != null ? 1 : 0,
        var.catalog.catalog_github != null ? 1 : 0,
        var.catalog.catalog_adogit != null ? 1 : 0
      ]) <= 1
    )
    error_message = "Only one source type can be defined for a catalog (git_hub, ado_git, catalog_github, or catalog_adogit)."
  }

  # Validation for sync_type values
  validation {
    condition = (
      var.catalog.sync_type == null ||
      contains(["Manual", "Scheduled"], var.catalog.sync_type)
    )
    error_message = "If provided, sync_type must be one of: Manual, Scheduled."
  }
}
