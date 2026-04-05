variable "portal_name" {
  description = "Portal name for ECS service"
  type        = string
}

variable "container_image" {
  description = "Container image for ECS tasks"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "cluster_arn" {
  description = "ECS cluster ARN"
  type        = string
}

variable "task_role_arn" {
  description = "IAM task role ARN"
  type        = string
}

variable "execution_role_arn" {
  description = "IAM execution role ARN"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}

variable "secret_arn" {
  description = "ARN of the portal secret"
  type        = string
}

variable "target_group_arn" {
  description = "Target group ARN for the portal service"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "ecs_sg_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}
