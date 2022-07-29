resource "aws_secretsmanager_secret" "secret_metadata" {
  name                    = var.secret_name
  recovery_window_in_days = var.recovery_window_in_days

  tags = {
    Environment = "dev"
  }
}

resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret_metadata.id
  secret_string = var.secret_value
}
