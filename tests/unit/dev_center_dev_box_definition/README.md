# DevBox Definition Unit Tests

This directory contains comprehensive unit tests for the Azure DevCenter DevBox Definition module.

## Test Coverage

The `devbox_definition_test.tftest.hcl` file includes the following test scenarios:

### 1. `test_basic_devbox_definition_with_id`
- Tests basic DevBox definition creation using `image_reference_id`
- Verifies that a simple DevBox definition with mandatory fields is created successfully
- Uses basic SKU name and hibernate support enabled

### 2. `test_devbox_definition_with_object`
- Tests DevBox definition creation using `image_reference` object format
- Verifies the alternative image reference configuration method
- Uses basic SKU name with hibernate support disabled

### 3. `test_hibernate_support`
- Specifically tests hibernate support configuration
- Verifies that hibernate support can be enabled for DevBox definitions
- Tests the boolean to string conversion for the Azure API

### 4. `test_storage_type`
- Tests OS storage type configuration
- Verifies that custom storage types can be specified
- Uses `os_storage_type` field with SSD configuration

### 5. `test_advanced_sku`
- Tests advanced SKU configuration using the SKU object
- Verifies that complex SKU configurations with name and tier work properly
- Tests the structured SKU approach vs simple SKU name

### 6. `test_naming_convention`
- Tests the azurecaf naming convention integration
- Verifies that different global settings affect resource naming
- Uses different prefixes and random length settings

### 7. `test_multiple_definitions`
- Tests multiple DevBox definitions in a single configuration
- Verifies that different configurations can coexist
- Tests both image reference formats and SKU configurations simultaneously

## Test Infrastructure

The tests use:
- Mock providers for `azapi` and `azurecaf`
- Predefined resource groups and dev centers for testing
- All required root module variables to ensure proper isolation

## Running Tests

### Individual Test File
```bash
cd tests/unit/dev_center_dev_box_definition
terraform test devbox_definition_test.tftest.hcl -verbose
```

### All DevBox Definition Tests
```bash
# From root directory (change to test directory and back)
cd tests/unit/dev_center_dev_box_definition && terraform test devbox_definition_test.tftest.hcl -verbose && cd ../../..
```

### All Unit Tests
```bash
./tests/run_tests.sh
```

## Test Results

All tests should pass successfully:
- ✅ 7 tests passing
- ✅ 0 tests failing
- ✅ Complete coverage of module functionality

## Notes

- The tests use mock Azure subscription IDs and resource paths
- Each test runs in isolation with its own variable overrides
- Tests verify both the creation logic and the output structure
- Schema validation is enabled to ensure Azure API compatibility
