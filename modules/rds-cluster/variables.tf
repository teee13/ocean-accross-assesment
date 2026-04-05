variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_username" {
  description = "DB admin username"
  type        = string
}

variable "db_password" {
  description = "DB admin password"
  type        = string
  sensitive   = true
}

variable "private_subnets" {
  description = "Private subnet IDs for RDS subnet group"
  type        = list(string)
}

variable "rds_sg_id" {
  description = "Security group ID for RDS"
  type        = string
}

variable "portals" {
  description = "List of portal database names"
  type        = list(string)
}
