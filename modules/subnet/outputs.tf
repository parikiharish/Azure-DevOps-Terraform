output "subnet_id" {
    description = "The ID of the subnet."
    value = azurerm_subnet.snt1.id
}

output "subnet_name" {
    description = "The name of the subnet."
    value = azurerm_subnet.snt1.name
}
