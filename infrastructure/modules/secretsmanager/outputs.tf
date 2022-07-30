output "secret_id" {
  description = "The ID of the secret"
  value       = aws_secretsmanager_secret_version.secret_version.id
}

output "secret_arn" {
  description = "The ARN of the secret"
  value       = aws_secretsmanager_secret_version.secret_version.arn
}
