# Additional variable for enhanced case
variable "domain_password" {
  description = "The password for the domain service account"
  type        = string
  sensitive   = true
}