variable "portal_name" {
  description = "Portal name for the task role"
  type        = string
}

variable "secret_arn" {
  description = "ARN of the portal secret"
  type        = string
  default     = ""
}

variable "s3_bucket_arn" {
  description = "ARN of the portal S3 bucket for task access"
  type        = string
  default     = ""
}
