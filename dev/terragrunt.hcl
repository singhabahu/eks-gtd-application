locals {
  region               = get_env("AWS_DEFAULT_REGION", "ap-southeast-2")
  bucket               = "${get_env("S3_STATE_BUCKET", "demo-eks-state")}-${get_aws_account_id()}"
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
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = local.bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    kms_key_id     = "alias/terraform-bucket-key"
    region         = local.region
    encrypt        = true
    dynamodb_table = "demo-eks-state-lock"
  }
}

inputs = {
  environment = "dev"
  region      = local.region
  bucket      = local.bucket
}
