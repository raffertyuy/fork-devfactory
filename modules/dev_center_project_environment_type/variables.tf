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

variable "dev_center_project_id" {
  description = "The ID of the Dev Center Project that will contain the environment type"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-f-]+/resourceGroups/[^/]+/providers/Microsoft\\.DevCenter/projects/[^/]+$", var.dev_center_project_id))
    error_message = "Dev Center Project ID must be a valid Azure resource ID for a Dev Center Project."
  }
}

variable "location" {
  description = "The location/region where the Dev Center Project Environment Type is created"
  type        = string
}

variable "project_environment_type" {
  description = "Configuration object for the Dev Center Project Environment Type"
  type = object({
    name                     = string
    environment_type_name    = string
    deployment_target_id     = string
    creator_role_assignment = optional(object({
      roles = list(string)
    }))
    user_role_assignments = optional(list(object({
      roles    = list(string)
      user_id  = optional(string)
    })))
    tags = optional(map(string))
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]$", var.project_environment_type.name)) && length(var.project_environment_type.name) >= 3 && length(var.project_environment_type.name) <= 63
    error_message = "Project environment type name must be between 3 and 63 characters long and can contain alphanumeric characters, periods, hyphens, and underscores. It must start and end with an alphanumeric character."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]*[a-zA-Z0-9]$", var.project_environment_type.environment_type_name)) && length(var.project_environment_type.environment_type_name) >= 3 && length(var.project_environment_type.environment_type_name) <= 128
    error_message = "Environment type name must be between 3 and 128 characters long and can contain alphanumeric characters, periods, hyphens, and underscores. It must start and end with an alphanumeric character."
  }
}