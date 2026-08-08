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
