variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "container_port" {
  description = "Container port used by ECS"
  type        = number
  default     = 80
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_username" {
  description = "RDS admin username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "RDS admin password"
  type        = string
  sensitive   = true
}

variable "portal_names" {
  description = "Portal names"
  type        = list(string)
  default     = ["Employee", "Company", "Bureaus"]
}

variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
  default     = "portal-app-cluster"
}

variable "ecr_repository_name" {
  description = "ECR repository name"
  type        = string
  default     = "portal-app-repo"
}

variable "kms_alias" {
  description = "KMS alias name"
  type        = string
  default     = "portal-app-key"
}

variable "terraform_state_bucket" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "portal-app-terraform-state"
}

variable "terraform_lock_table" {
  description = "DynamoDB table name for Terraform state locking"
  type        = string
  default     = "portal-app-terraform-locks"
}
