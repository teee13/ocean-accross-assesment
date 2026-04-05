output "service_name" {
  value = aws_ecs_service.portal.name
}

output "service_arn" {
  value = aws_ecs_service.portal.arn
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.portal.arn
}
