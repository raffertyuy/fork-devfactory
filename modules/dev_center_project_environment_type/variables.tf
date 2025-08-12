# DevCenter Project Environment Type Module Variables

variable "global_settings" {
  description = "Global settings for the module"
  type = object({
    prefixes      = optional(list(string), [])
    random_length = optional(number, 0)
    passthrough   = optional(bool, false)
    use_slug      = optional(bool, true)
    tags          = optional(map(string), {})
  })
  default = {}
}

variable "project_environment_type" {
  description = "Configuration object for the DevCenter Project Environment Type"
  type = object({
    status = optional(string, "Enabled")
    creator_role_assignment = optional(object({
      roles = list(string)
    }))
    tags = optional(map(string), {})
  })
  default = {}

  validation {
    condition     = var.project_environment_type.status == null || contains(["Enabled", "Disabled"], var.project_environment_type.status)
    error_message = "Status must be either 'Enabled' or 'Disabled'."
  }
}

variable "dev_center_project_id" {
  description = "The ID of the Dev Center Project that will contain the environment type"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-f-]+/resourceGroups/[^/]+/providers/Microsoft\\.DevCenter/projects/[^/]+$", var.dev_center_project_id))
    error_message = "Dev Center Project ID must be a valid Azure resource ID for a Dev Center Project."
  }
}

variable "environment_type_id" {
  description = "The ID of the Dev Center Environment Type to link to this project"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/[0-9a-f-]+/resourceGroups/[^/]+/providers/Microsoft\\.DevCenter/devcenters/[^/]+/environmentTypes/[^/]+$", var.environment_type_id))
    error_message = "Environment Type ID must be a valid Azure resource ID for a Dev Center Environment Type."
  }
}

variable "deployment_target_id" {
  description = "The ID of the deployment target (subscription or resource group) for environments of this type"
  type        = string

  validation {
    condition = can(regex("^/subscriptions/[0-9a-f-]+(/resourceGroups/[^/]+)?$", var.deployment_target_id))
    error_message = "Deployment target ID must be a valid Azure subscription ID or resource group ID."
  }
}

variable "location" {
  description = "The Azure region where the project environment type will be created"
  type        = string
  default     = "eastus"

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be a valid Azure region."
  }
}