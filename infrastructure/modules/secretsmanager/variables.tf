variable "secret_name" {
  description = "Name of the secret to be created"
  type        = string
}

variable "secret_value" {
  description = "Value of the secret to be created"
  type        = string
}

variable "recovery_window_in_days" {
  description = "Number of days AWS Secret Manager waits before it can delete a secret"
  type        = number
  default     = 0
}
