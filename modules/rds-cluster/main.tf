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
}

resource "aws_db_subnet_group" "main" {
  name       = "main-db-subnet-group"
  subnet_ids = var.private_subnets

  tags = {
    Name = "main-db-subnet-group"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "portal-app-db"
  engine                 = "postgres"
  engine_version         = "15"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [var.rds_sg_id]
  skip_final_snapshot    = true
  publicly_accessible    = false

  tags = {
    Name = "portal-app-postgres"
  }
}

resource "random_password" "portal_passwords" {
  for_each = toset(var.portals)
  length   = 16
  special  = true
}
