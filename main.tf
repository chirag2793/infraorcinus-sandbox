resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_storage_account" "sa" {
  name                            = "stio${var.suffix}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  account_kind                    = "StorageV2"
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = var.public_blob_access
  public_network_access_enabled   = var.public_network_access
  tags                            = local.tags
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-io-${var.suffix}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-io-${var.suffix}"
  address_space       = ["10.77.0.0/24"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = local.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.77.0.0/27"]
}

resource "azurerm_subnet_network_security_group_association" "assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
