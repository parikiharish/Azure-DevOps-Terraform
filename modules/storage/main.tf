resource "azurerm_storage_account" "storage1" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  https_traffic_only_enabled      = true
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false
  local_user_enabled              = false

  tags = {
    environment = "dev"
    project     = "azure-devops-terraform"
    managed_by  = "terraform"
  }
}

resource "azurerm_storage_container" "container1" {
  name                  = var.container_name
  storage_account_id    = azurerm_storage_account.storage1.id
  container_access_type = "private"
}