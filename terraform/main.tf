terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.22.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
    azapi = {
      source  = "azure/azapi"
      version = "=2.3.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.1.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.subscription_id
}

resource "random_string" "unique" {
  length  = 8
  special = false
  upper   = false
}

data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "default" {
  name                = "DefaultWorkspace-${data.azurerm_client_config.current.subscription_id}-${local.loc_short}"
  resource_group_name = "DefaultResourceGroup-${local.loc_short}"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-${local.gh_repo}-${random_string.unique.result}-${local.loc_for_naming}"
  location = var.location
  tags     = local.tags
}

resource "azuread_application" "example" {
  display_name = "spn-${local.gh_repo}-${random_string.unique.result}"
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "example" {
  client_id                    = azuread_application.example.client_id
  app_role_assignment_required = false
  owners                       = [data.azurerm_client_config.current.object_id]
}

resource "azurerm_graph_services_account" "example" {
  depends_on = [azuread_service_principal.example, azuread_application.example]

  name                = "myGraphAppBilling1"
  resource_group_name = azurerm_resource_group.rg.name
  application_id      = azuread_application.example.client_id
  tags = merge(local.tags, {
    "team" = "implodingduck"
  })
}

resource "azurerm_resource_group" "rg2" {
  name     = "rg-${local.gh_repo}-${random_string.unique.result}-${local.loc_for_naming}-yag"
  location = var.location
  tags     = local.tags
}

resource "azuread_application" "example2" {
  display_name = "spn-${local.gh_repo}-${random_string.unique.result}-yaa"
  owners       = [data.azurerm_client_config.current.object_id]
}

resource "azuread_service_principal" "example2" {
  client_id                    = azuread_application.example2.client_id
  app_role_assignment_required = false
  owners                       = [data.azurerm_client_config.current.object_id]
}

resource "azurerm_graph_services_account" "example2" {
  depends_on = [azuread_service_principal.example2, azuread_application.example2]

  name                = "myGraphAppBilling2"
  resource_group_name = azurerm_resource_group.rg2.name
  application_id      = azuread_application.example2.client_id
  tags = merge(local.tags, {
    "team" = "scroogemcduck"
  })
}