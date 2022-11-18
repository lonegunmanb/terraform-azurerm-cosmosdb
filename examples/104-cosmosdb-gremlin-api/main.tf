resource "random_pet" "pet" {
  length = 1
}

locals {
  resource_group_name = coalesce(var.resource_group_name, "example-cosmosdb-${random_pet.pet.id}")
}

# Resource group 
resource "azurerm_resource_group" "this" {
  name     = local.resource_group_name
  location = var.location
}

module "azure_cosmos_db" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  cosmos_account_name = var.cosmos_account_name
  cosmos_api          = var.cosmos_api
  gremlin_dbs         = var.gremlin_dbs
  gremlin_graphs      = var.gremlin_graphs
  depends_on = [
    azurerm_resource_group.this
  ]
}