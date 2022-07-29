output "account_id" {
  description = "AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}

output "state_bucket_name" {
  description = "Name of the state bucket"
  value       = aws_s3_bucket.terraform_state_bucket.bucket
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.state_lock.name
}
