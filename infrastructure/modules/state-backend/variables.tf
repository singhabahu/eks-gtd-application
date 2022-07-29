variable "state_bucket_name" {
  type    = string
  default = "demo-eks-state"
}

variable "dynamodb_table_name" {
  type    = string
  default = "demo-eks-state-lock"
}
