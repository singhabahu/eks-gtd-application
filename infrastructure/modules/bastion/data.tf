data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = "${var.bucket}"
    region = "${var.region}"
    key    = "${var.vpc_key}"
  }
}

data "http" "public_ip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_ami" "bastion_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_iam_policy_document" "bastion_eks_policy_document" {
  statement {
    actions = [
      "eks:*",
    ]

    resources = [
      "arn:aws:eks:${var.region}:${var.account_id}:cluster/${var.eks_cluster_name}"
    ]
  }
}

data "aws_iam_policy_document" "bastion_sts_policy_document" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
