variable "vpc_key" {
  description = "Path to the VPC state file"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "bucket" {
  description = "State bucket name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "security_group_name" {
  description = "Security group name for the bastion"
  type        = string
  default     = "bastion-security-group"
}

variable "max_session_duration" {
  description = "The maximum session duration (in seconds) that set for the specified role"
  default     = 3600
}

variable "key_pair_name" {
  description = "Name of the key pair"
  type        = string
  default     = "bastion"
}

variable "role_name" {
  description = "Name of the role"
  type        = string
  default     = "bastion-role"
}

variable "policy_name" {
  description = "Name of the policy"
  type        = string
  default     = "bastion-policy"
}

variable "instance_profile_name" {
  description = "Name of the instance profile"
  type        = string
  default     = "bastion-instance-profile"
}

variable "launch_configuration_name" {
  description = "Name of the launch configuration"
  type        = string
  default     = "bastion-launch-configuration"
}

variable "autoscaling_group_name" {
  description = "Name of the autoscaling group"
  type        = string
  default     = "bastion-autoscaling-group"
}

variable "autoscaling_group_configs" {
  description = "The autoscaling group configs"
  type        = map(string)
  default = {
    min_size         = 1
    max_size         = 3
    desired_capacity = 1
  }
}

variable "instance_type" {
  description = "Instance type of the bastion server"
  type        = string
  default     = "t2.medium"
}

variable "environment" {
  description = "Name of the environment"
  type        = string
}
