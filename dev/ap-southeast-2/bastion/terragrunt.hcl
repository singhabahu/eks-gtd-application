locals {
  region           = get_env("AWS_DEFAULT_REGION", "ap-southeast-2")
  account_id       = get_aws_account_id()
  eks_cluster_name = get_env("EKS_CLUSTER_NAME", "demo-eks-cluster")
}

terraform {
  source = "../../../infrastructure/modules//bastion"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vpc_key          = "${local.region}/vpc/terraform.tfstate"
  account_id       = local.account_id
  eks_cluster_name = local.eks_cluster_name
}
