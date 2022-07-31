output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster"
  value       = try(module.eks.cluster_arn, "")
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = try(module.eks.cluster_endpoint, "")
}

output "cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  value       = try(module.eks.cluster_id, "")
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = try(module.eks.cluster_version, "")
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = try(module.eks.cluster_security_group_id, "")
}

output "cluster_node_security_group_id" {
  description = "ID of the node shared security group"
  value       = try(module.eks.node_security_group_id, "")
}

output "load_balancer_controller_policy" {
  description = "IAM policy ARN of the load balancer controller policy"
  value       = aws_iam_policy.load_balancer_controller_policy.arn
}

output "load_balancer_controller_role" {
  description = "IAM policy ARN of the load balancer controller role"
  value       = aws_iam_role.load_balancer_controller_role.arn
}
