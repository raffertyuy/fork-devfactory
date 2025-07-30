variable "global_settings" {
  description = "Global settings for resource naming and tagging"
  type = object({
    prefixes      = optional(list(string), [])
    random_length = optional(number, 3)
    passthrough   = optional(bool, false)
    use_slug      = optional(bool, true)
    tags          = optional(map(string), {})
  })
  default = {}
}

variable "project_environment_type" {
  description = "Configuration for the Dev Center project environment type"
  type = object({
    name                 = string
    deployment_target_id = string
    status               = optional(string, "Enabled")
    display_name         = optional(string)
    creator_role_assignment = optional(object({
      roles = map(object({}))
    }))
    user_role_assignments = optional(map(object({
      roles = map(object({}))
    })))
    identity = optional(object({
      type         = string
      identity_ids = optional(list(string), [])
    }))
    tags = optional(map(string), {})
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_.]{2,62}$", var.project_environment_type.name))
    error_message = "Name must be 3-63 characters, start with alphanumeric, and contain only alphanumeric, hyphens, underscores, and periods."
  }

  validation {
    condition     = contains(["Enabled", "Disabled"], try(var.project_environment_type.status, "Enabled"))
    error_message = "Status must be either 'Enabled' or 'Disabled'."
  }
}

variable "project_id" {
  description = "The resource ID of the DevCenter project"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-f-]+/resourceGroups/[^/]+/providers/Microsoft\\.DevCenter/projects/[^/]+$", var.project_id))
    error_message = "Project ID must be a valid Azure resource ID for a DevCenter project."
  }
}

variable "location" {
  description = "The Azure region where the resource will be created"
  type        = string
}
