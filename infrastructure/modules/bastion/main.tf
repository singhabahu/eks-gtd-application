resource "aws_launch_configuration" "launch_configuration" {
  name                        = var.launch_configuration_name
  image_id                    = data.aws_ami.bastion_ami.id
  instance_type               = var.instance_type
  associate_public_ip_address = "true"
  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  security_groups             = [aws_security_group.security_group.id]
  key_name                    = aws_key_pair.key_pair.key_name

  lifecycle {
    create_before_destroy = true
  }
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
