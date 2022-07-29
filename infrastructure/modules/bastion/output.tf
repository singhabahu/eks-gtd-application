output "bastion_security_group" {
  description = "The security group ID for the bastion"
  value       = aws_security_group.security_group.id
}

output "bastion_iam_role" {
  description = "The IAM role of the bastion"
  value       = aws_iam_role.role.arn
}
