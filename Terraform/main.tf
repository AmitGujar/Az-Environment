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
  address_space = [ "192.168.0.0/16" ]
  location = "centralindia"
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "my_terraform_subnet" {
  name = "mySubnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["192.168.1.0/24"]
}