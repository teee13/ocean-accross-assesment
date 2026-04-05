resource "aws_vpc_endpoint" "s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  route_table_ids   = var.route_table_ids
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "portal-app-s3-endpoint"
  }
}

data "aws_region" "current" {}
