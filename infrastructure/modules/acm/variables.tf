variable "region" {
  description = "AWS region"
  type        = string
}

variable "common_name" {
  type    = string
  default = "elb.amazonaws.com"
}

variable "organization" {
  type    = string
  default = "Servian Pty Ltd"
}
