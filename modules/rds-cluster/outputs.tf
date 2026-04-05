output "address" {
  value = aws_db_instance.postgres.address
}

output "port" {
  value = aws_db_instance.postgres.port
}

output "instance_id" {
  value = aws_db_instance.postgres.id
}

output "portal_passwords" {
  value     = { for k, v in random_password.portal_passwords : k => v.result }
  sensitive = true
}
