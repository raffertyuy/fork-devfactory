module "dev_center_catalogs" {
  source   = "./modules/dev_center_catalog"
  for_each = try(var.dev_center_catalogs, {})

  global_settings = var.global_settings
  catalog         = each.value
  catalog_git = {
    catalog_github = try(each.value.catalog_github, null)
    catalog_adogit = try(each.value.catalog_adogit, null)
  }
  dev_center_id       = lookup(each.value, "dev_center_id", null) != null ? each.value.dev_center_id : module.dev_centers[each.value.dev_center.key].id
  resource_group_name = lookup(each.value, "resource_group_name", null) != null ? each.value.resource_group_name : module.resource_groups[each.value.resource_group.key].name
}
