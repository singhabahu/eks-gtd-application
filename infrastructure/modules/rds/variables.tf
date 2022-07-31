variable "vpc_key" {
  description = "Path to the VPC state file"
  type        = string
}

variable "eks_key" {
  description = "Path to the EKS state file"
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

variable "rds_configuration" {
  description = "RDS configuration"
  type        = map(any)
  default = {
    identifier        = "demo-postgres"
    engine            = "postgres"
    instance_class    = "db.t3.small"
    engine_version    = "13.4"
    allocated_storage = "5"
    db_name           = "demo_db"
    username          = "demo_user"
    port              = "5432"
    multi_az          = true
    family            = "postgres13"
  }
}
