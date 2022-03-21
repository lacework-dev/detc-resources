output "resource_group_name" {
  description = "azure aks resource group name"
  value       = azurerm_resource_group.default.name
}

output "cluster_id" {
  description = "azure aks cluster id"
  value       = azurerm_kubernetes_cluster.default.id
}

output "cluster_name" {
  description = "azure aks cluster name"
  value       = azurerm_kubernetes_cluster.default.name
}

output "cluster_endpoint" {
  description = "azure aks cluster endpoint for control plane"
  value       = "https://${azurerm_kubernetes_cluster.default.fqdn}"
}

output "kubectl_config" {
  description = "kubectl config file"
  sensitive   = true
  value       = azurerm_kubernetes_cluster.default.kube_config_raw
}
