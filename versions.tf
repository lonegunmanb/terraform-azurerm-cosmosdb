# Azure provider version
terraform {
  required_version = ">= 1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = ">=1.0.0"
    }
  }
}