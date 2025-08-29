# Random password generator
resource "random_password" "database" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# AWS Secrets Manager secret
resource "aws_secretsmanager_secret" "database" {
  name = "webapp/${var.environment}/database"
  # Add this for automatic deletion
  recovery_window_in_days = 0  # 0 = immediate deletion, 7-30 = waiting period
  
  tags = {
    Name        = "${var.environment}-database-secret"
    Environment = var.environment
  }
}

# Secret version with actual credentials
resource "aws_secretsmanager_secret_version" "database" {
  secret_id = aws_secretsmanager_secret.database.id
  secret_string = jsonencode({
    username = "webapp_user"
    password = random_password.database.result
    dbname   = var.database_name
    engine   = "mysql"
    host     = "" # Will be updated after RDS is created
  })
}