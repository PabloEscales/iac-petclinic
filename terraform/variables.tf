variable "resource_group_name" {
  default = "rg-iac-petclinic-poel-dev"
}

variable "resource_group_location" {
  default = "northeurope"
}

variable "virtual_network_name" {
  default = "vnet-iac-petclinic-poel-dev"
}

variable "subnet_kubernetes_name" {
  default = "kubernetes"
}

variable "subnet_database_name" {
  default = "database"
}

variable "azurerm_kubernetes_cluster" {
  default = "aks-iac-petclinic-poel-dev"
}

variable "azurerm_user_assigned_identity" {
  default = "user-identity-aks"
}
