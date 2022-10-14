provider "azurerm" {
  # whilst the `version` attribute is optional, we recommend pinning to a given version of the Provider
  features {}
}
data "azurerm_subscription" "current" {}

resource "azurerm_resource_group" "rgazurelive" {
  name     = "rg${local.alias}"
  location = local.region
}
resource "azurerm_servicebus_namespace" "servicebus_namespace" {
  name                = "asb${local.alias}01"
  location            = azurerm_resource_group.rgazurelive.location
  resource_group_name = azurerm_resource_group.rgazurelive.name
  sku                 = "Standard"
}
resource "azurerm_servicebus_queue" "azurelive" {
  name                = "clientes"
  resource_group_name = azurerm_resource_group.rgazurelive.name
  namespace_name      = azurerm_servicebus_namespace.servicebus_namespace.name

  enable_partitioning = true
}
resource "azurerm_logic_app_workflow" "logic_app_workflow" {
  name                = "alp${local.alias}01"
  location            = azurerm_resource_group.rgazurelive.location
  resource_group_name = azurerm_resource_group.rgazurelive.name
}
resource "azurerm_storage_account" "storage_account" {
  name                     = "stg${local.alias}01"
  resource_group_name      = azurerm_resource_group.rgazurelive.name
  location                 = azurerm_resource_group.rgazurelive.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "asp${local.alias}01"
  location            = azurerm_resource_group.rgazurelive.location
  resource_group_name = azurerm_resource_group.rgazurelive.name
  kind                = "FunctionApp"

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_function_app" "azurelive" {
  name                      = "fpp${local.alias}01"
  location                  = azurerm_resource_group.rgazurelive.location
  resource_group_name       = azurerm_resource_group.rgazurelive.name
  app_service_plan_id       = azurerm_app_service_plan.app_service_plan.id
  storage_connection_string = azurerm_storage_account.storage_account.primary_connection_string
}
