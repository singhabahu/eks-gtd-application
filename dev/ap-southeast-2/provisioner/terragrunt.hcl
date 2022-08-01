locals {
  region            = get_env("AWS_DEFAULT_REGION", "ap-southeast-2")
  access_key_id     = get_env("AWS_ACCESS_KEY_ID")
  secret_access_key = get_env("AWS_SECRET_ACCESS_KEY")
  eks_cluster_name  = get_env("EKS_CLUSTER_NAME", "demo-eks-cluster")
  bucket            = "${get_env("S3_STATE_BUCKET", "demo-eks-state")}-${get_aws_account_id()}"
}

terraform {
  source = "../../../infrastructure/modules//provisioner"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  bucket                = local.bucket
  bastion_key           = "${local.region}/bastion/terraform.tfstate"
  eks_key               = "${local.region}/eks/terraform.tfstate"
  acm_key               = "${local.region}/acm/terraform.tfstate"
  rds_key               = "${local.region}/rds/terraform.tfstate"
  aws_access_key_id     = local.access_key_id
  aws_secret_access_key = local.secret_access_key
  aws_default_region    = local.region
  eks_cluster_name      = local.eks_cluster_name
}
