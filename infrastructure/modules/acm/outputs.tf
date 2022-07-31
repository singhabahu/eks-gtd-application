output "acm_certificate" {
  description = "The ACM certificate ARN"
  value       = aws_acm_certificate.acm_certificate.arn
}
