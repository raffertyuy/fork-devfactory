variable "global_settings" {
  description = "Global settings object"
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

variable "deployment_target_id" {
  description = "The ID of the deployment target for the environment type"
  type        = string
}

variable "project_environment_type" {
  description = "Configuration object for the Project Environment Type"
  type = object({
    name = string
    tags = optional(map(string), {})
    
    # Environment type status
    status = optional(string, "Enabled") # "Enabled" or "Disabled"
    
    # Creator role assignment configuration
    creator_role_assignment = optional(object({
      roles = list(string)
    }))
    
    # User role assignments configuration
    user_role_assignments = optional(map(object({
      roles = list(string)
    })), {})
  })
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-_]*[a-zA-Z0-9]$", var.project_environment_type.name)) || length(var.project_environment_type.name) == 1
    error_message = "Environment type name must start and end with an alphanumeric character and can contain letters, numbers, underscores, and hyphens."
  }
  
  validation {
    condition     = contains(["Enabled", "Disabled"], try(var.project_environment_type.status, "Enabled"))
    error_message = "Status must be either 'Enabled' or 'Disabled'."
  }
}