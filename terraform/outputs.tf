output "resource_group_id" {
  value = azurerm_resource_group.rg.name
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vnet.name
}

output "aks_cluster_name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "kubernetes_version" {
  value = azurerm_kubernetes_cluster.aks.kubernetes_version
}
