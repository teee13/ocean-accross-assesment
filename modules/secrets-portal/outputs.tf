output "secret_arn" {
  value = aws_secretsmanager_secret.portal.arn
}

output "secret_name" {
  value = aws_secretsmanager_secret.portal.name
}
