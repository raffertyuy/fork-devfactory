module "dev_center_project_environment_types" {
  source   = "./modules/dev_center_project_environment_type"
  for_each = var.dev_center_project_environment_types

  global_settings          = var.global_settings
  project_environment_type = each.value
  
  # Get the project ID from the referenced project if using key reference, otherwise use direct ID
  dev_center_project_id = lookup(each.value, "dev_center_project_id", null) != null ? each.value.dev_center_project_id : module.dev_center_projects[each.value.project.key].id
  
  # Use the deployment target ID from the configuration
  deployment_target_id = each.value.deployment_target_id

  depends_on = [
    module.dev_center_projects
  ]
}