data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "${var.bucket}"
    region = "${var.region}"
    key    = "${var.vpc_key}"
  }
}

data "terraform_remote_state" "bastion" {
  backend = "s3"
  config = {
    bucket = "${var.bucket}"
    region = "${var.region}"
    key    = "${var.bastion_key}"
  }
}
