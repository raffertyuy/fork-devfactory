variable "global_settings" {
  description = "Global settings object"
  type = object({
    prefixes      = optional(list(string))
    random_length = optional(number)
    passthrough   = optional(bool)
    use_slug      = optional(bool)
  })
}

variable "resource_group_name" {
  description = "The name of the resource group in which the Dev Center exists"
  type        = string
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be a non-empty string."
  }
}

variable "dev_center_id" {
  description = "The ID of the Dev Center in which to create the catalog"
  type        = string
  validation {
    condition     = length(var.dev_center_id) > 0
    error_message = "Dev Center ID must be a non-empty string."
  }
}

variable "catalog_git" {
  description = "Configuration object for the Dev Center Catalog Git repository"
  type = object({
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
  })

  # Validate that at least one catalog source type is specified when needed
  validation {
    condition = (
      (try(var.catalog_git.catalog_github, null) != null) ||
      (try(var.catalog_git.catalog_adogit, null) != null) ||
      true # This makes validation pass when neither is specified
    )
    error_message = "At least one catalog source (catalog_github or catalog_adogit) must be specified."
  }
}

variable "catalog" {
  description = "Configuration object for the Dev Center Catalog"
  type = object({
    name                       = string
    description                = optional(string)
    maximum_dev_boxes_per_user = optional(number)
    tags                       = optional(map(string))
  })
}