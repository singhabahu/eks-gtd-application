locals {
  region = get_env("AWS_DEFAULT_REGION", "ap-southeast-2")
}

terraform {
  source = "../../../infrastructure/modules//rds"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vpc_key = "${local.region}/vpc/terraform.tfstate"
  eks_key = "${local.region}/eks/terraform.tfstate"
}
