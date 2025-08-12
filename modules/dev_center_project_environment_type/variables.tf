variable "global_settings" {
  description = "Global settings object for naming conventions and tags"
  type = object({
    prefixes      = optional(list(string))
    random_length = optional(number)
    passthrough   = optional(bool)
    use_slug      = optional(bool)
    tags          = optional(map(string), {})
  })
}

variable "dev_center_project_id" {
  description = "The ID of the Dev Center Project in which to create the environment type"
  type        = string
}

variable "location" {
  description = "The location/region where the Project Environment Type is created"
  type        = string
}

variable "deployment_target_id" {
  description = "The ID of the deployment target (subscription) for the environment type"
  type        = string
}

variable "project_environment_type" {
  description = "Configuration object for the project environment type"
  type = object({
    name         = string
    display_name = optional(string)
    status       = optional(string, "Enabled") # "Enabled", "Disabled"
    tags         = optional(map(string), {})

    # Creator role assignment configuration
    creator_role_assignment = optional(object({
      roles = map(object({
        role_definition_id = string
      }))
    }))

    # User role assignments configuration
    user_role_assignments = optional(map(object({
      roles = map(object({
        role_definition_id = string
      }))
    })))
  })

  validation {
    condition     = contains(["Enabled", "Disabled"], var.project_environment_type.status)
    error_message = "Status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_.]{1,62}[a-zA-Z0-9]$", var.project_environment_type.name))
    error_message = "Environment type name must be 3-63 characters, start and end with alphanumeric, and contain only alphanumeric, hyphens, underscores, and periods."
  }
}