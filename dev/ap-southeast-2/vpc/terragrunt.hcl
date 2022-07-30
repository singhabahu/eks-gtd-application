locals {
  eks_cluster_name = get_env("EKS_CLUSTER_NAME", "demo-eks-cluster")
}

terraform {
  source = "../../../infrastructure/modules//vpc"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  eks_cluster_name = local.eks_cluster_name
}
