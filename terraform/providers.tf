
# Configure the Microsoft Azure Provider
provider "azurerm" {
    # resource_provider_registrations = "none" # This is only required when the User, Service Principal, or Managed Identity does not have the Microsoft.Compute resource provider registered in the subscription. This is only required for the first time you use the provider in a subscription.
    features{}
}
