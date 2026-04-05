variable "vpc_id" {
  description = "VPC ID for endpoint"
  type        = string
}

variable "route_table_ids" {
  description = "Route table IDs to associate with the endpoint"
  type        = list(string)
}
