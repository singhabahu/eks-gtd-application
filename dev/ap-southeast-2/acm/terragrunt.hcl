locals {
  region = get_env("AWS_DEFAULT_REGION", "ap-southeast-2")
}

terraform {
  source = "../../../infrastructure/modules//acm"
}

include "root" {
  path = find_in_parent_folders()
}

inputs = {
  region = local.region
}
