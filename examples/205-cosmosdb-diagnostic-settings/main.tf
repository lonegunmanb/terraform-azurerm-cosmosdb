resource "random_pet" "pet" {
  length = 1
}

locals {
  log_analytics_workspace_name = coalesce(var.log_analytics_workspace_name, "cosmosdb${random_pet.pet.id}")
  resource_group_name = coalesce(var.resource_group_name, "example-cosmosdb-${random_pet.pet.id}")
}

resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = local.log_analytics_workspace_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

module "azure_cosmos_db" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  cosmos_account_name = var.cosmos_account_name
  cosmos_api          = var.cosmos_api
  sql_dbs             = var.sql_dbs
  sql_db_containers   = var.sql_db_containers
  log_analytics = {
    workspace = {
      la_workspace_name    = azurerm_log_analytics_workspace.this.name
      la_workspace_rg_name = azurerm_log_analytics_workspace.this.resource_group_name
    }
  }
  depends_on = [
    azurerm_resource_group.this,
    azurerm_log_analytics_workspace.this
  ]
}