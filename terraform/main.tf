module "resource_group" {
  source              = "../modules/resource-group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "virtual_network" {
  source               = "./modules/network"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = module.resource_group.resource_group_name
  location             = var.location
  address_space        = var.address_space
}