variable "virtual_network_name" {
  description = "Virtual Network."
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name."
  type        = string
}

variable "location" {
  description = "Azure Region."
  type        = string
}

variable "address_space" {
  description = "Address space for the virtual network."
  type        = list(string)
}
