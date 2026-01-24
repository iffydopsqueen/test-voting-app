output "db_secrets_arn" {
  value = aws_secretsmanager_secret.db_secrets.arn
}

output "db_secrets_name" {
  value = aws_secretsmanager_secret.db_secrets.name
}