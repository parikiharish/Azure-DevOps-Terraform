module "resource_group" {
  source              = "../modules/resource-group"
  resource_group_name = var.resource_group_name
  location            = var.location
}


module "virtual_network" {
  source               = "../modules/network"
  virtual_network_name = var.virtual_network_name
  resource_group_name  = module.resource_group.resource_group_name
  location             = var.location
  address_space        = var.address_space
}

module "subnet" {
  source               = "../modules/subnet"
  subnet_name          = var.subnet_name
  virtual_network_name = module.virtual_network.virtual_network_name
  resource_group_name  = module.resource_group.resource_group_name
  address_prefixes     = var.address_prefixes
}
module "nsg" {
  source              = "../modules/nsg"
  nsg_name            = var.nsg_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  security_rules      = var.security_rules
}
module "nsg_association" {
  source                    = "../modules/nsg-association"
  subnet_id                 = module.subnet.subnet_id
  network_security_group_id = module.nsg.nsg_id
}

#Storage account
module "storage" {
  source               = "../modules/storage"
  storage_account_name = var.storage_account_name
  resource_group_name  = module.resource_group.resource_group_name
  location             = var.location
  container_name       = var.container_name
}

