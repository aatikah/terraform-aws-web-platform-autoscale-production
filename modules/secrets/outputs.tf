output "database_secret_arn" {
  description = "ARN of the database secret"
  value       = aws_secretsmanager_secret.database.arn
  sensitive   = true
}

output "database_password" {
  description = "Database password"
  value       = random_password.database.result
  sensitive   = true
}