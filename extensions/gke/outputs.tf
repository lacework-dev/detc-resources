
output "cluster_endpoint" {
  description = "GKE cluster endpoint for control plane"
  value       = "https://${module.gke.endpoint}"
  sensitive   = true
}

output "cluster_name" {
  description = "cluster name"
  value       = var.cluster_name
}

output "kubectl_config" {
  description = "kubectl config file"
  value       = module.gke_auth.kubeconfig_raw
  sensitive   = true
}

output "host" {
  description = "kubectl host"
  value       = module.gke_auth.host
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "kubectl cluster ca certificate"
  value       = module.gke_auth.cluster_ca_certificate
  sensitive   = true
}

output "token" {
  description = "kubectl token"
  value       = module.gke_auth.token
  sensitive   = true
}

output "network" {
  value = module.vpc.network_id
}

output "subnet" {
  value = module.vpc.subnets_ids[0]
}
