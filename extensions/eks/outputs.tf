
output "cluster_id" {
  description = "EKS cluster id"
  value       = module.eks.cluster_id
}

output "cluster_arn" {
  description = "value"
  value       = module.eks.cluster_arn
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint for control plane"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids for EKS cluster control plane"
  value       = module.eks.cluster_security_group_id
}

output "cluster_worker_security_group_id" {
  description = "Security group ids for EKS worker nodes"
  value       = aws_security_group.all_worker_mgmt.id
}

output "region" {
  description = "EKS region"
  value       = var.aws_region
}

output "cluster_name" {
  description = "EKS Cluster Name"
  value       = local.cluster_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = module.vpc.public_subnets
}

output "private_subnet_id" {
  value = module.vpc.private_subnets
}

