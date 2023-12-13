terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.51.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.12.1"
    }

   kubernetes = {
      config_path = pathexpand("~/.kube/config")  # O ajusta la ruta según tu configuración
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "kubernetes" {
  name                 = var.subnet_kubernetes_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "database" {
  name                 = var.subnet_database_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/28"]
}

resource "azurerm_network_security_group" "kubernetes_nsg" {
  name                = "${var.subnet_kubernetes_name}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_network_security_group" "database_nsg" {
  name                = "${var.subnet_database_name}-nsg"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_user_assigned_identity" "my_identity" {
  name                = var.azurerm_user_assigned_identity
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.azurerm_kubernetes_cluster
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aks-poel-dev"
  sku_tier            = "Free"

  default_node_pool {
    name       = "backendpool"
    node_count = 3
    vm_size    = "Standard_B2s"
  }

  network_profile {
    network_plugin = "kubenet"
    dns_service_ip = "10.0.1.10"
    service_cidr   = "10.0.1.0/24"
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.my_identity.id]
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "default"
  version    = "4.8.3"
 
  set {
    name  = "controller.scope.enabled"
    value = "true"
  }
 
  set {
    name  = "controller.service.externalTrafficPolicy"
    value = "Local"
  }
 
  depends_on = [azurerm_kubernetes_cluster.aks]
}
