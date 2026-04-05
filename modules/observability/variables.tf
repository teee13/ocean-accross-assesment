variable "log_group_names" {
  description = "List of CloudWatch log group names"
  type        = list(string)
}

variable "retention_in_days" {
  description = "Log retention in days"
  type        = number
  default     = 30
}
