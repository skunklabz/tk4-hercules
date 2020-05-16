provider "azurerm" {
  version = "~> 2.1.0"
  features {}
}

resource "azurerm_resource_group" "tk4rg" {
  name     = "tk4acirg"
  location = "west us"
}

resource "azurerm_storage_account" "tk4sa" {
  name                     = "tk4acisa"
  resource_group_name      = azurerm_resource_group.tk4rg.name
  location                 = azurerm_resource_group.tk4rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_share" "tk4sh" {
  name                 = "tk4acish"
  storage_account_name = azurerm_storage_account.tk4sa.name
  quota                = 50
}

resource "azurerm_container_group" "tk4cg" {
  name                = "tk4acicg"
  location            = azurerm_resource_group.tk4rg.location
  resource_group_name = azurerm_resource_group.tk4rg.name
  ip_address_type     = "public"
  os_type             = "linux"

  container {
    name = "tk4"
    image = "skunklabz/tk4-hercules:latest"
    cpu ="0.5"
    memory =  "1.5"

    ports {
      port     = "3270"
      protocol = "TCP"
    }

    volume {
      name = "conf"
      mount_path = "/tk4-/conf"
      read_only = false
      share_name = azurerm_storage_share.tk4sh.name
      storage_account_name = azurerm_storage_account.tk4sa.name
      storage_account_key = azurerm_storage_account.tk4sa.primary_access_key
    }

    volume {
      name = "localconf"
      mount_path = "/tk4-/local_conf"
      read_only = false
      share_name = azurerm_storage_share.tk4sh.name
      storage_account_name = azurerm_storage_account.tk4sa.name
      storage_account_key = azurerm_storage_account.tk4sa.primary_access_key
    }

    volume {
      name = "localscripts"
      mount_path = "/tk4-/local_scripts"
      read_only = false
      share_name = azurerm_storage_share.tk4sh.name
      storage_account_name = azurerm_storage_account.tk4sa.name
      storage_account_key = azurerm_storage_account.tk4sa.primary_access_key
    }

    volume {
      name = "prt"
      mount_path = "/tk4-/prt"
      read_only = false
      share_name = azurerm_storage_share.tk4sh.name
      storage_account_name = azurerm_storage_account.tk4sa.name
      storage_account_key = azurerm_storage_account.tk4sa.primary_access_key
    }

    volume {
      name = "dasd"
      mount_path = "/tk4-/dasd"
      read_only = false
      share_name = azurerm_storage_share.tk4sh.name
      storage_account_name = azurerm_storage_account.tk4sa.name
      storage_account_key = azurerm_storage_account.tk4sa.primary_access_key
    }

    volume {
      name = "pch"
      mount_path = "/tk4-/pch"
      read_only = false
      share_name = azurerm_storage_share.tk4sh.name
      storage_account_name = azurerm_storage_account.tk4sa.name
      storage_account_key = azurerm_storage_account.tk4sa.primary_access_key
    }

    volume {
      name = "jcl"
      mount_path = "/tk4-/jcl"
      read_only = false
      share_name = azurerm_storage_share.tk4sh.name
      storage_account_name = azurerm_storage_account.tk4sa.name
      storage_account_key = azurerm_storage_account.tk4sa.primary_access_key
    }

    volume {
      name = "log"
      mount_path = "/tk4-/log"
      read_only = false
      share_name = azurerm_storage_share.tk4sh.name
      storage_account_name = azurerm_storage_account.tk4sa.name
      storage_account_key = azurerm_storage_account.tk4sa.primary_access_key
    }
  }
}