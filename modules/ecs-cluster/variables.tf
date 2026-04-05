variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where ECS container instances will run"
  type        = string
}

variable "private_subnets" {
  description = "Private subnet IDs for ECS container instances"
  type        = list(string)
}

variable "instance_type" {
  description = "EC2 instance type for ECS container instances"
  type        = string
  default     = "t3.micro"
}

variable "asg_desired_capacity" {
  description = "Desired number of ECS container instances"
  type        = number
  default     = 1
}

variable "asg_min_size" {
  description = "Minimum number of ECS container instances"
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of ECS container instances"
  type        = number
  default     = 1
}
