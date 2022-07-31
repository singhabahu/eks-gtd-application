module "database_security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "database-security-group"
  description = "Security group for PostgreSQL"

  vpc_id = data.terraform_remote_state.vpc.outputs.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = var.rds_configuration["port"]
      to_port                  = var.rds_configuration["port"]
      protocol                 = "tcp"
      source_security_group_id = data.terraform_remote_state.eks.outputs.cluster_node_security_group_id
      description              = "EKS access for RDS"
    },
  ]
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier             = var.rds_configuration["identifier"]
  engine                 = var.rds_configuration["engine"]
  instance_class         = var.rds_configuration["instance_class"]
  engine_version         = var.rds_configuration["engine_version"]
  allocated_storage      = var.rds_configuration["allocated_storage"]
  db_name                = var.rds_configuration["db_name"]
  username               = var.rds_configuration["username"]
  port                   = var.rds_configuration["port"]
  multi_az               = var.rds_configuration["multi_az"]
  subnet_ids             = data.terraform_remote_state.vpc.outputs.database_subnets
  family                 = var.rds_configuration["family"]
  vpc_security_group_ids = [module.database_security_group.security_group_id]
  db_subnet_group_name   = data.terraform_remote_state.vpc.outputs.database_subnet_group_name
}

module "secretsmanager_database_password" {
  source       = "../secretsmanager"
  secret_name  = "database_password/${var.rds_configuration["identifier"]}"
  secret_value = module.db.db_instance_password
}

module "secretsmanager_database_username" {
  source       = "../secretsmanager"
  secret_name  = "database_username/${var.rds_configuration["identifier"]}"
  secret_value = module.db.db_instance_username
}
