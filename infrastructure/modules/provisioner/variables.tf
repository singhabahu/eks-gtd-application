variable "aws_access_key_id" {
  description = "AWS access key ID"
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS secret key"
  type        = string
}

variable "aws_default_region" {
  description = "AWS defaultregion"
  type        = string
  default     = "ap-southeast-2"
}

variable "eks_cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "demo-eks-cluster"
}

variable "bastion_key" {
  description = "Path to the bastion state file"
  type        = string
}

variable "eks_key" {
  description = "Path to the EKS state file"
  type        = string
}

variable "acm_key" {
  description = "Path to the ACM state file"
  type        = string
}

variable "rds_key" {
  description = "Path to the RDS state file"
  type        = string
}

variable "bucket" {
  description = "State bucket name"
  type        = string
}
