module "dev_center_project_environment_types" {
  source   = "./modules/dev_center_project_environment_type"
  for_each = try(var.dev_center_project_environment_types, {})

  global_settings          = var.global_settings
  project_environment_type = each.value
  location                 = lookup(each.value, "location", null) != null ? each.value.location : try(module.resource_groups[each.value.resource_group.key].location, var.location)
  dev_center_project_id    = lookup(each.value, "dev_center_project_id", null) != null ? each.value.dev_center_project_id : module.dev_center_projects[each.value.project.key].id
  deployment_target_id     = each.value.deployment_target_id

  depends_on = [
    module.dev_center_projects
  ]
}