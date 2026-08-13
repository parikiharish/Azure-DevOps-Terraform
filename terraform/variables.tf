variable "resource_group_name" {
  description = "Name of the Azure Resources"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "virtual_network_name" {
  description = "Name of the Virtual Network"
  type        = string
}

variable "address_space" {
  description = "Virtual Network Address Space"
  type        = list(string)
}

variable "subnet_name" {
  description = "Name of the Subnet"
  type        = string
}
variable "address_prefixes" {
  description = "Subnet Address Prefixes"
  type        = list(string)
}
variable "nsg_name" {
  description = "Name of the Network Security Group"
  type        = string
}
variable "security_rules" {
  description = "List of security rules for the Network Security Group"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}

#Storage account
variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
}

variable "container_name" {
  description = "The name of the container to create in the storage account."
  type        = string
}
