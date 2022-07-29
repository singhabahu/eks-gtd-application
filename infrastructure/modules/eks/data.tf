data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "${var.bucket}"
    region = "${var.region}"
    key    = "${var.vpc_key}"
  }
}
