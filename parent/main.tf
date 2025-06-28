module "resource_group" {
  source = "../modules/azurerm_resource_group"

  resource_group_name     = "sarrg"
  resource_group_location = "centralindia"

}
module "frontendpip" {
  depends_on              = [module.resource_group]
  source                  = "../modules/azurerm_pip"
  resource_group_name     = "sarrg"
  resource_group_location = "centralindia"
  pip_name                = "frontendpip"


}

module "backendpip" {
  depends_on              = [module.resource_group]
  source                  = "../modules/azurerm_pip"
  resource_group_name     = "sarrg"
  resource_group_location = "centralindia"
  pip_name                = "backendpip"

}


module "vnet" {
  depends_on              = [module.resource_group]
  source                  = "../modules/azurerm_virtual_network"
  resource_group_name     = "sarrg"
  resource_group_location = "centralindia"
  virtual_network_name    = "myVNet"
  address_space           = ["10.0.0.0/16"]
}
module "frontendsubnet" {
  depends_on           = [module.vnet]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = "sarrg"
  virtual_network_name = "myVNet"
  subnet_name          = "myfrontendSubnet"
  address_prefixes     = ["10.0.1.0/24"]
}
module "backendsubnet" {
  depends_on           = [module.vnet]
  source               = "../modules/azurerm_subnet"
  resource_group_name  = "sarrg"
  virtual_network_name = "myVNet"
  subnet_name          = "mybackendSubnet"
  address_prefixes     = ["10.0.2.0/24"]
}
module "frontendvm" {
  depends_on                   = [module.backendsubnet, module.frontendsubnet,module.keyvault,module.key_vault_secret]
  source                       = "../modules/azurerm_virtual_machine"
  resource_group_name          = "sarrg"
  resource_group_location      = "centralindia"
  namahnic_name                = "frontendnic"
  subnet_name                  = "myfrontendSubnet"
  virtual_network_name         = "myVNet"
  azurerm_virtual_machine_name = "namahfrontend"
  pip_name                     = "backendpip"
  vmpassword                   = "bacpassword"
  vmusername                   = "usernamehai"
  key_vault_name              = "namahkeyvault"
}
module "backendvm" {
  depends_on                   = [module.backendsubnet, module.frontendsubnet,module.keyvault,module.key_vault_secret]
  source                       = "../modules/azurerm_virtual_machine"
  resource_group_name          = "sarrg"
  resource_group_location      = "centralindia"
  namahnic_name                = "backendnic"
  subnet_name                  = "mybackendSubnet"
  virtual_network_name         = "myVNet"
  azurerm_virtual_machine_name = "namahbackend"
  pip_name                     = "frontendpip"
  vmpassword                   = "bacpassword"
  vmusername                   = "usernamehai"
  key_vault_name              = "namahkeyvault"
}



module "sqlserver" {
  depends_on                           = [module.resource_group]
  source                               = "../modules/azurerm_sql_server"
  azurerm_mssql_server_name            = "namahsqlserver"
  azurerm_mssql_administrator_name     = "namahsqlserveradmin"
  azurerm_administrator_login_password = "Namah@1234"
  azurerm_resource_group_name          = "sarrg"
  azurerm_location                     = "centralindia"
  namahsqlserver_version               = "12.0"
}
module "sqlda" {
  depends_on                  = [module.sqlserver]
  source                      = "../modules/azurerm_sql_database"
  azurerm_mssql_server_name   = "namahsqlserver"
  azurerm_mssql_database_name = "namahsqldatabase"
  azurerm_resource_group_name = "sarrg"

}
module "keyvault" {
  depends_on              = [module.resource_group]
  source                  = "../modules/azurerm_keyvault"
  resource_group_name     = "sarrg"
  resource_group_location = "centralindia"
  key_vault_name          = "namahkeyvault"
}
module "key_vault_secret" {
  depends_on          = [module.keyvault]
  source              = "../modules/azurerm_keyvault_secret"
  resource_group_name = "sarrg"
  key_vault_name      = "namahkeyvault"
  vmusername          = "usernamehai"
  vmusernamevalue     = "dummyadmin"
  vmpassword          = "bacpassword"
  vmpasswordvalue     = "Dummyadmin@1234"
}