output "association_id" {
  description = "The ID of the subnet network security group association."
  value       = azurerm_subnet_network_security_group_association.nsg1.id
}