global_settings = {
  prefixes = ["devfactory"]
  suffixes = ["001"]
  tags = {
    environment = "development"
    project     = "devfactory"
  }
}

resource_groups = {
  "loadtest_rg" = {
    name   = "loadtest-resources"
    region = "eastus"
  }
}

load_tests = {
  "basic_load_test" = {
    name               = "basic-load-test"
    resource_group_key = "loadtest_rg"
    description        = "Basic load testing service for development"
    tags = {
      purpose = "load-testing"
    }
  }
}
