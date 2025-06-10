output "rgname" {
  value = azurerm_resource_group.rg.name
}

output "spn_client_id" {
  value = azuread_application.example.client_id
}
