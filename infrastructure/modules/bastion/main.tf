locals {
  bastion_userdata = <<USERDATA
#!/bin/bash
set -o xtrace
cat <<EOF > /etc/profile.d/bastion.sh
export PATH=$PATH:/usr/local/bin
EOF

yum update -y

# Install HELM
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Install KUBECTL
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
USERDATA
}

resource "aws_launch_configuration" "launch_configuration" {
  name                        = var.launch_configuration_name
  image_id                    = data.aws_ami.bastion_ami.id
  instance_type               = var.instance_type
  associate_public_ip_address = "true"
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  security_groups             = [aws_security_group.security_group.id]
  key_name                    = aws_key_pair.key_pair.key_name
  user_data_base64            = base64encode(local.bastion_userdata)
}

resource "aws_autoscaling_group" "autoscaling_group" {
  desired_capacity     = var.autoscaling_group_configs["desired_capacity"]
  max_size             = var.autoscaling_group_configs["max_size"]
  min_size             = var.autoscaling_group_configs["min_size"]
  vpc_zone_identifier  = data.terraform_remote_state.vpc.outputs.public_subnets
  launch_configuration = aws_launch_configuration.launch_configuration.id
  name                 = var.autoscaling_group_name

  tag {
    key                 = "Name"
    value               = "${var.eks_cluster_name}-bastion"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "dev"
    propagate_at_launch = true
  }
}
