output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "portal_target_group_arns" {
  value = module.alb.portal_target_group_arns
}

output "cluster_arn" {
  value = module.ecs_cluster.cluster_arn
}

output "db_address" {
  value = module.rds_cluster.address
}

output "db_port" {
  value = module.rds_cluster.port
}

output "security_group_ids" {
  value = {
    alb = module.security.alb_sg_id
    ecs = module.security.ecs_sg_id
    rds = module.security.rds_sg_id
  }
}

output "repository_url" {
  value = module.ecr.repository_url
}

output "master_db_secret_arn" {
  value = aws_secretsmanager_secret.master_db_secret.arn
}

output "portal_secret_arns" {
  value = { for k, v in aws_secretsmanager_secret.portal_secrets : k => v.arn }
}

output "kms_key_arn" {
  value = module.kms.key_arn
}

output "vpc_id" {
  value = module.networking.vpc_id
}

output "terraform_state_bucket" {
  value = module.terraform_backend.s3_bucket_name
}

output "terraform_lock_table" {
  value = module.terraform_backend.dynamodb_table_name
}
