variable "vpc_key" {
  description = "Path to the VPC state file"
  type        = string
}

variable "bastion_key" {
  description = "Path to the bastion state file"
  type        = string
}

variable "bucket" {
  description = "State bucket name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "eks_cluster_name" {
  description = "The EKS cluster name"
  type        = string
  default     = "demo-eks-cluster"
}

variable "eks_cluster_version" {
  description = "The EKS cluster K8 version"
  type        = string
  default     = "1.22"
}

variable "eks_cluster_addons_versions" {
  description = "The EKS cluster addon versions"
  type        = map(string)
  default = {
    coredns    = "v1.8.7-eksbuild.1"
    kube-proxy = "v1.22.11-eksbuild.2"
    vpc-cni    = "v1.11.2-eksbuild.1"
  }
}

variable "eks_managed_node_group" {
  description = "The EKS cluster managed node group configs"
  type = object({
    ami_type       = string
    disk_size      = number
    min_size       = number
    max_size       = number
    desired_size   = number
    instance_types = list(string)
    capacity_type  = string
  })

  default = {
    ami_type       = "AL2_x86_64"
    disk_size      = 10
    min_size       = 1
    max_size       = 3
    desired_size   = 1
    instance_types = ["t3.medium"]
    capacity_type  = "ON_DEMAND"
  }
}

variable "load_balancer_controller_policy_name" {
  description = "The load balancer controller policy name"
  type        = string
  default     = "AWSLoadBalancerControllerIAMPolicy"
}

variable "max_session_duration" {
  description = "The maximum session duration (in seconds) that set for the specified role"
  default     = 3600
}

variable "load_balancer_controller_role_name" {
  description = "The load balancer controller role name"
  type        = string
  default     = "AWSLoadBalancerControllerRole"
}
