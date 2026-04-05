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
    bucket         = "tenant-app-terraform-state"
    key            = "shared-platform/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "tenant-app-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
}

module "terraform_backend" {
  source              = "../../modules/terraform-backend"
  bucket_name         = var.terraform_state_bucket
  dynamodb_table_name = var.terraform_lock_table
  region              = var.region
}

module "networking" {
  source          = "../../modules/networking"
  region          = var.region
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "security" {
  source         = "../../modules/security"
  vpc_id         = module.networking.vpc_id
  container_port = var.container_port
}

module "kms" {
  source     = "../../modules/kms"
  alias_name = var.kms_alias
}

module "rds_cluster" {
  source            = "../../modules/rds-cluster"
  db_instance_class = var.db_instance_class
  db_username       = var.db_username
  db_password       = var.db_password
  private_subnets   = module.networking.private_subnets
  rds_sg_id         = module.security.rds_sg_id
  portals           = var.portal_names
}

module "ecs_cluster" {
  source       = "../../modules/ecs-cluster"
  cluster_name = var.cluster_name
}

module "alb" {
  source         = "../../modules/alb"
  portal_names   = var.portal_names
  public_subnets = module.networking.public_subnets
  alb_sg_id      = module.security.alb_sg_id
  vpc_id         = module.networking.vpc_id
}

module "ecr" {
  source          = "../../modules/ecr"
  repository_name = var.ecr_repository_name
}

module "vpc_endpoints" {
  source          = "../../modules/vpc-endpoints"
  vpc_id          = module.networking.vpc_id
  route_table_ids = [module.networking.route_table_public_id, module.networking.route_table_private_id]
}

module "observability" {
  source          = "../../modules/observability"
  log_group_names = ["shared-platform"]
}
