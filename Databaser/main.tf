resource "azurerm_resource_group" "rg" {
  name     = "database-rg-test-tihlde-drift"  # Ensure this name remains unchanged
  location = var.resource_group_location
}

resource "random_password" "password" {
  count       = var.admin_password == null ? 1 : 0
  length      = 20
  special     = true
  min_numeric = 1
  min_upper   = 1
  min_lower   = 1
  min_special = 1
}

resource "random_id" "server_suffix" {
  byte_length = 4
}

locals {
  admin_password = try(random_password.password[0].result, var.admin_password)
}

resource "azurerm_mssql_server" "server" {
  name                         = "${var.resource_group_name_prefix}-sql-server-${random_id.server_suffix.hex}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  administrator_login          = var.admin_username
  administrator_login_password = local.admin_password
  version                      = "12.0"
}

resource "azurerm_mssql_database" "db" {
  name      = var.sql_db_name
  server_id = azurerm_mssql_server.server.id
}
