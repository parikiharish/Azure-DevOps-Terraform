# DEV Resource group 
resource_group_name  = "rg-dev"
location             = "East US"
virtual_network_name = "vnet-dev"
address_space        = ["10.0.0.0/16"]
subnet_name          = "subnet-dev-web"
address_prefixes     = ["10.0.1.0/24"]
nsg_name             = "nsg-dev-web"
security_rules = [
  {
    name                       = "Allow-Https"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },

  {
    name                       = "Allow-SSH"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "192.168.1.11/32"
    destination_address_prefix = "*"
  },
  {
    name                       = "Allow-RDP"
    priority                   = 130
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "192.168.1.11/32"
    destination_address_prefix = "*"
  }
]

#Storage account
storage_account_name = "devtfstorageaccount"
container_name       = "devtfstoragecontainer"