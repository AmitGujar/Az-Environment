terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">=1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = "centralindia"

  tags = {
    Environment = "Terraform Test"
    Team = "DevOps"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name = "terraformVnet"
  address_space = [ "10.0.0.0/16" ]
  location = "centralindia"
  resource_group_name = azurerm_resource_group.rg.name
}