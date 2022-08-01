terraform {
  source = "../../../infrastructure/modules//state-backend"
}

locals {
  region               = get_env("AWS_DEFAULT_REGION", "ap-southeast-2")
  bucket               = get_env("S3_STATE_BUCKET", "demo-eks-state")
  aws_provider_version = "4.23.0"
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.aws_provider_version}"
    }
  }
}

provider "aws" {
  region = "${local.region}"
}
EOF
}

remote_state {
  backend = "local"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    path = "${get_original_terragrunt_dir()}/terraform.tfstate"
  }
}

inputs = {
  state_bucket_name = local.bucket
}
