resource "aws_secretsmanager_secret" "db_secrets" {
  name = "db_secretss"

    tags = {
        Name = "db_secretss"
    }
}

# Store the database credentials as a secret
resource "aws_secretsmanager_secret_version" "db_secrets_value" {
  secret_id     = aws_secretsmanager_secret.db_secrets.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
    })
}
