locals {
  region           = get_env("AWS_DEFAULT_REGION", "ap-southeast-2")
  eks_cluster_name = get_env("EKS_CLUSTER_NAME", "demo-eks-cluster")
}

terraform {
  source = "../../../infrastructure/modules//eks"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vpc_key          = "${local.region}/vpc/terraform.tfstate"
  bastion_key      = "${local.region}/bastion/terraform.tfstate"
  eks_cluster_name = local.eks_cluster_name
}
