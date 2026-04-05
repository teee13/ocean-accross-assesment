output "log_group_names" {
  value = aws_cloudwatch_log_group.this[*].name
}

output "log_group_arns" {
  value = aws_cloudwatch_log_group.this[*].arn
}
