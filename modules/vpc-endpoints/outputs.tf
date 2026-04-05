output "endpoint_id" {
  value = aws_vpc_endpoint.s3.id
}

output "service_name" {
  value = aws_vpc_endpoint.s3.service_name
}
