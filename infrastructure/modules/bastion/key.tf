resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

module "secretsmanager_private_key" {
  source       = "../secretsmanager"
  secret_name  = "ssh/private_key/${var.key_pair_name}"
  secret_value = tls_private_key.rsa_key.private_key_pem
}

module "secretsmanager_public_key" {
  source       = "../secretsmanager"
  secret_name  = "ssh/public_key/${var.key_pair_name}"
  secret_value = tls_private_key.rsa_key.public_key_openssh
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${var.key_pair_name}-${var.environment}"
  public_key = tls_private_key.rsa_key.public_key_openssh
}
