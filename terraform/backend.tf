terraform {
  backend "azurerm" {
    resource_group_name  = "tf-auto-rg"
    storage_account_name = "terraformazstorage"
    container_name       = "tfazdevops"
    key                  = "terraform.tfstate"

    use_azuread_auth = true
    use_oidc         = true
  }
}