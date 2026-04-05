variable "portal_names" {
  description = "List of portal names for ALB routing"
  type        = list(string)
}

variable "public_subnets" {
  description = "Public subnet IDs for ALB"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "Security group ID for ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for ALB target groups"
  type        = string
}
