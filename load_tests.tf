# Azure Load Test Resources
# This file orchestrates the creation of Azure Load Testing services for high-scale load generation

module "load_tests" {
  source = "./modules/load_test"

  for_each = var.load_tests

  load_test           = each.value
  location            = module.resource_groups[each.value.resource_group_key].location
  resource_group_name = module.resource_groups[each.value.resource_group_key].name
  global_settings     = var.global_settings
}
