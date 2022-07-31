output "secretsmanager_database_password" {
  description = "Secrets Manager ARN for the database password"
  value       = module.secretsmanager_database_password.secret_arn
}

output "secretsmanager_database_username" {
  description = "Secrets Manager ARN for the database username"
  value       = module.secretsmanager_database_username.secret_arn
}

output "db_instance_port" {
  description = "The database port"
  value       = module.db.db_instance_port
}

output "db_instance_name" {
  description = "The database name"
  value       = module.db.db_instance_name
}

output "db_instance_address" {
  description = "The database address"
  value       = module.db.db_instance_address
}
