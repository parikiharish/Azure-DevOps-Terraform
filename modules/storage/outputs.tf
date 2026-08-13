output "storage_account_id" {
  description = "The ID of the storage account."
  value       = azurerm_storage_account.storage1.id
}

output "storage_account_name" {
  description = "The name of the storage account."
  value       = azurerm_storage_account.storage1.name
}

output "contiainer_name" {
  description = "The name of the storage container."
  value       = azurerm_storage_container.container1.name
}