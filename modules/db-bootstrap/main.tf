data "aws_secretsmanager_secret_version" "master_secret" {
  secret_id = "master-database-secret"
}

locals {
  master_secret = jsondecode(data.aws_secretsmanager_secret_version.master_secret.secret_string)
  db_password   = local.master_secret.db_password
}

resource "null_resource" "bootstrap_db" {
  triggers = {
    db_name = var.db_name
  }

  provisioner "local-exec" {
    command = <<EOT
      PGPASSWORD=${local.db_password} psql -h ${var.db_host} -U ${var.db_username} -d postgres -c "CREATE DATABASE ${var.db_name};"
    EOT
  }
}
