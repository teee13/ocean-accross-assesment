data "aws_secretsmanager_secret_version" "master_secret" {
  secret_id = "master-database-secret"
}

locals {
  master_secret = jsondecode(data.aws_secretsmanager_secret_version.master_secret.secret_string)
  db_password   = local.master_secret.db_password
}

resource "aws_secretsmanager_secret" "portal" {
  name = "${var.portal_name}-secrets"

  tags = {
    Name = var.portal_name
  }
}

resource "aws_secretsmanager_secret_version" "portal" {
  secret_id = aws_secretsmanager_secret.portal.id
  secret_string = jsonencode({
    db_host     = var.db_host
    db_port     = var.db_port
    db_name     = var.db_name
    db_username = var.db_username
    db_password = local.db_password
  })
}
