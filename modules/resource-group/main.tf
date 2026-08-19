resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    environment       = "dev"
    managed_by        = "terraform"
  }
}