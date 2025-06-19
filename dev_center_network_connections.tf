# Dev Center Network Connections module instantiation
module "dev_center_network_connections" {
  source   = "./modules/dev_center_network_connection"
  for_each = try(var.dev_center_network_connections, {})

  global_settings                 = var.global_settings
  dev_center_network_connection   = each.value
  resource_group_name             = lookup(each.value, "resource_group_name", null) != null ? each.value.resource_group_name : module.resource_groups[each.value.resource_group.key].name
  location                        = lookup(each.value, "region", null) != null ? each.value.region : module.resource_groups[each.value.resource_group.key].location
}