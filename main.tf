terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.43.0"
    }
  }
}

provider "azurerm" {
  features {}

  # Configuración de autenticación
  client_id       = "e36e151d-ee7a-407d-a4bd-9488b73dbae2"
  tenant_id       = "cc28633f-12b8-46cb-bc15-951dae239b4d"
  subscription_id = "b2d9fefb-c48f-4126-b1f4-67bd7caa8366"
  client_secret   = " nBS8Q~_1njjrBEOSgPx-UKstM0jov2Okmvc_kasu "
}

# Recurso auxiliar para crear sufijo aleatorio (asegura nombre único)
resource "random_integer" "suffix" {
  min = 10000
  max = 99999
}

locals {
  # Lista de regiones disponibles
  regions = {
    "Brazil South"   = "Brazil South"
    "East US"        = "East US"
    "Mexico Central" = "Mexico Central"
    "Chile Central"  = "Chile Central"
  }

  # Región seleccionada
  selected_region = local.regions["Chile Central"]
}

# Grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "rg-ucb-proyectofinal-sisifo"
  location = local.selected_region
}

# Storage Account (corregido con depends_on y nombre único)
resource "azurerm_storage_account" "sa" {
  name                     = "saucbexamen225599"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  allow_nested_items_to_be_public = true

  depends_on = [azurerm_resource_group.rg]
}

# Contenedores
resource "azurerm_storage_container" "bronze" {
  name                  = "bronze"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "container"
}

resource "azurerm_storage_container" "silver" {
  name                  = "silver"
  storage_account_id    = azurerm_storage_account.sa.id
  container_access_type = "container"
}

# Archivos CSV en el contenedor bronze
resource "azurerm_storage_blob" "Categoria" {
  name                   = "category.csv"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.bronze.name
  type                   = "Block"
  source                 = "dataset/category.csv"
}

resource "azurerm_storage_blob" "Productos" {
  name                   = "products.csv"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.bronze.name
  type                   = "Block"
  source                 = "dataset/products.csv"
}

resource "azurerm_storage_blob" "Ventas" {
  name                   = "sales.csv"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.bronze.name
  type                   = "Block"
  source                 = "dataset/sales.csv"
}

resource "azurerm_storage_blob" "Tiendas" {
  name                   = "stores.csv"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.bronze.name
  type                   = "Block"
  source                 = "dataset/stores.csv"
}

resource "azurerm_storage_blob" "Garantia" {
  name                   = "warranty.csv"
  storage_account_name   = azurerm_storage_account.sa.name
  storage_container_name = azurerm_storage_container.bronze.name
  type                   = "Block"
  source                 = "dataset/warranty.csv"
}

# Servidor SQL
resource "azurerm_mssql_server" "sqlserver" {
  name                         = "sql-ucb-sisinfo12152"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "aleloayza"
  administrator_login_password = "Al16$loayza"
  public_network_access_enabled = true
}

# Bases de datos (corregidas con storage_account_type)
resource "azurerm_mssql_database" "bronze_examenFinal" {
  name                  = "bronze-examenFinal"
  server_id             = azurerm_mssql_server.sqlserver.id
  sku_name              = "S0"
  collation             = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb           = 10
  zone_redundant        = false
  storage_account_type  = "Local"
}

resource "azurerm_mssql_database" "silver_examenFinal" {
  name                  = "silver-examenFinal"
  server_id             = azurerm_mssql_server.sqlserver.id
  sku_name              = "S0"
  collation             = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb           = 10
  zone_redundant        = false
  storage_account_type  = "Local"
}

# Regla de firewall para permitir acceso público
resource "azurerm_mssql_firewall_rule" "allow_all" {
  name              = "allow_all"
  server_id         = azurerm_mssql_server.sqlserver.id
  start_ip_address  = "0.0.0.0"
  end_ip_address    = "255.255.255.255"
}

# Data Factory
resource "azurerm_data_factory" "adf" {
  name                = "adf-ucb-examenFinal-157865"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
