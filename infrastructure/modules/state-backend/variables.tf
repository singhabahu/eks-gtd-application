variable "state_bucket_name" {
  description = "The name of the state bucket"
  type        = string
  default     = "demo-eks-state"
}

variable "dynamodb_table_name" {
  description = "The name of the dynamodb table"
  type        = string
  default     = "demo-eks-state-lock"
}
