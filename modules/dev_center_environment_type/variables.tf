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

variable "dev_center_id" {
  description = "The ID of the Dev Center that will contain the environment type"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-f-]+/resourceGroups/[^/]+/providers/Microsoft\\.DevCenter/devcenters/[^/]+$", var.dev_center_id))
    error_message = "Dev Center ID must be a valid Azure resource ID for a Dev Center."
  }
}

variable "environment_type" {
  description = "Configuration object for the Dev Center Environment Type"
  type = object({
    name         = string
    display_name = optional(string)
    tags         = optional(map(string))
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]$", var.environment_type.name)) && length(var.environment_type.name) >= 3 && length(var.environment_type.name) <= 128
    error_message = "Environment type name must be between 3 and 128 characters long and can contain alphanumeric characters, periods, hyphens, and underscores. It must start and end with an alphanumeric character."
  }
}
