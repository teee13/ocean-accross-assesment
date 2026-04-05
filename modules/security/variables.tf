variable "vpc_id" {
  description = "VPC ID for security groups"
  type        = string
}

variable "container_port" {
  description = "Port used by container services"
  type        = number
}
