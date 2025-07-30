# Dev Center Project Environment Types module instantiation
module "dev_center_project_environment_types" {
  source   = "./modules/dev_center_project_environment_type"
  for_each = try(var.dev_center_project_environment_types, {})

  global_settings          = var.global_settings
  project_environment_type = each.value
  project_id               = lookup(each.value, "project_id", null) != null ? each.value.project_id : module.dev_center_projects[each.value.project.key].id
  location                 = lookup(each.value, "region", null) != null ? each.value.region : "eastus"
}
