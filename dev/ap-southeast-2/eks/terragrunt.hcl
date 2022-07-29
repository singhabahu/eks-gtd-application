locals {
  region = get_env("AWS_REGION", "ap-southeast-2")
}

terraform {
  source = "../../../infrastructure/modules//eks"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  vpc_key = "${local.region}/vpc/terraform.tfstate"
}
