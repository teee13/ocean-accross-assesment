variable "portal_name" {
  description = "Portal name for the SSM parameter"
  type        = string
}

variable "parameter_value" {
  description = "Value to store in SSM"
  type        = string
}

variable "parameter_key" {
  description = "SSM parameter key"
  type        = string
}
