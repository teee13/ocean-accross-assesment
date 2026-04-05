output "service_name" {
  value = module.ecs_service.service_name
}

output "service_arn" {
  value = module.ecs_service.service_arn
}

output "secret_arn" {
  value = data.aws_secretsmanager_secret.portal_secret.arn
}

output "bucket_name" {
  value = module.s3_storage.bucket_name
}

output "ssm_parameter_name" {
  value = module.ssm.parameter_name
}
