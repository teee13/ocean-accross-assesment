variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "portal_name" {
  description = "Portal name"
  type        = string
  default     = "Employee"
}

variable "container_image" {
  description = "Container image for portal ECS service"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Container port for portal ECS service"
  type        = number
  default     = 80
}

variable "cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN for this portal"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "ECS security group ID"
  type        = string
}

variable "db_host" {
  description = "Database host"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = number
}

variable "db_username" {
  description = "Database username"
  type        = string
}
