data "aws_instance" "bastion_instance" {
  filter {
    name   = "tag:Name"
    values = ["${var.eks_cluster_name}-bastion"]
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"
  config = {
    bucket = "${var.bucket}"
    region = "${var.aws_default_region}"
    key    = "${var.eks_key}"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"
  config = {
    bucket = "${var.bucket}"
    region = "${var.aws_default_region}"
    key    = "${var.bastion_key}"
  }
}

data "terraform_remote_state" "acm" {
  backend = "s3"
  config = {
    bucket = "${var.bucket}"
    region = "${var.aws_default_region}"
    key    = "${var.acm_key}"
  }
}

data "terraform_remote_state" "rds" {
  backend = "s3"
  config = {
    bucket = "${var.bucket}"
    region = "${var.aws_default_region}"
    key    = "${var.rds_key}"
  }
}

data "aws_secretsmanager_secret" "private_key_metadata" {
  arn = data.terraform_remote_state.bastion.outputs.secretsmanager_private_key
}

data "aws_secretsmanager_secret_version" "private_key_version" {
  secret_id = data.aws_secretsmanager_secret.private_key_metadata.id
}

data "aws_secretsmanager_secret" "database_password_metadata" {
  arn = data.terraform_remote_state.rds.outputs.secretsmanager_database_password
}

data "aws_secretsmanager_secret_version" "database_password_version" {
  secret_id = data.aws_secretsmanager_secret.database_password_metadata.id
}

data "aws_secretsmanager_secret" "database_username_metadata" {
  arn = data.terraform_remote_state.rds.outputs.secretsmanager_database_username
}

data "aws_secretsmanager_secret_version" "database_username_version" {
  secret_id = data.aws_secretsmanager_secret.database_username_metadata.id
}
