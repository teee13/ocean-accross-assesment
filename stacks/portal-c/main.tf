terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket         = "portal-app-terraform-state"
    key            = "portal-c/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "portal-app-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

data "aws_secretsmanager_secret" "portal_secret" {
  name = "${var.portal_name}-secrets"
}

data "aws_secretsmanager_secret_version" "portal_secret" {
  secret_id = data.aws_secretsmanager_secret.portal_secret.id
}

module "s3_storage" {
  source      = "../../modules/s3-portal-storage"
  portal_name = var.portal_name
}

module "ssm" {
  source          = "../../modules/ssm-portal"
  portal_name     = var.portal_name
  parameter_key   = "config"
  parameter_value = data.aws_secretsmanager_secret.portal_secret.arn
}

module "iam_task_role" {
  source        = "../../modules/iam-task-role"
  portal_name   = var.portal_name
  secret_arn    = data.aws_secretsmanager_secret.portal_secret.arn
  s3_bucket_arn = module.s3_storage.bucket_arn
}

resource "aws_s3_bucket_policy" "portal_storage" {
  bucket = module.s3_storage.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEcsTaskRoleListBucket"
        Effect = "Allow"
        Principal = {
          AWS = module.iam_task_role.task_role_arn
        }
        Action = [
          "s3:ListBucket"
        ]
        Resource = module.s3_storage.bucket_arn
      },
      {
        Sid    = "AllowEcsTaskRoleObjectActions"
        Effect = "Allow"
        Principal = {
          AWS = module.iam_task_role.task_role_arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:HeadObject"
        ]
        Resource = "${module.s3_storage.bucket_arn}/*"
      }
    ]
  })
}

module "observability" {
  source          = "../../modules/observability"
  log_group_names = ["/ecs/${var.portal_name}"]
}

module "ecs_service" {
  source             = "../../modules/ecs-service"
  portal_name        = var.portal_name
  container_image    = var.container_image
  container_port     = var.container_port
  cluster_arn        = var.cluster_arn
  task_role_arn      = module.iam_task_role.task_role_arn
  execution_role_arn = module.iam_task_role.execution_role_arn
  log_group_name     = module.observability.log_group_names[0]
  secret_arn         = data.aws_secretsmanager_secret.portal_secret.arn
  target_group_arn   = var.target_group_arn
  private_subnets    = var.private_subnets
  ecs_sg_id          = var.ecs_sg_id
}
