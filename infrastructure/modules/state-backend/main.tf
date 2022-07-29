# Generates the bucket name with the AWS account ID to avoid conflicts
locals {
  bucket_name = "${var.state_bucket_name}-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket        = local.bucket_name
  force_destroy = true

  lifecycle {
    ignore_changes = [bucket]
  }
}

resource "aws_s3_bucket_acl" "terraform_state_bucket_acl" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_kms_key" "terraform_state_bucket_key" {
  deletion_window_in_days = 7
  enable_key_rotation     = true
}

resource "aws_kms_alias" "terraform_state_bucket_key_alias" {
  name          = "alias/terraform-bucket-key"
  target_key_id = aws_kms_key.terraform_state_bucket_key.key_id
}

# Provides a S3 bucket server-side encryption configuration resource using KMS
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_bucket_encryption" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.terraform_state_bucket_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Manages S3 bucket-level Public Access Block configuration
resource "aws_s3_bucket_public_access_block" "terraform_state_bucket_access_block" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enforce TLS (HTTPS) and version of the TLS protocol to be greater than 1.2
resource "aws_s3_bucket_policy" "bucket" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "STATE-BUCKET-TLS-POLICY"
    Statement = [
      {
        Sid       = "EnforceTLS"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.terraform_state_bucket.arn,
          "${aws_s3_bucket.terraform_state_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
          NumericLessThan = {
            "s3:TlsVersion" : 1.2
          }
        }
      },
    ]
  })
}

# Uses to manage for state locks
resource "aws_dynamodb_table" "state_lock" {
  depends_on   = [aws_s3_bucket.terraform_state_bucket]
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
