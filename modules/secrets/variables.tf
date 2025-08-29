variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "database_name" {
  description = "Name of the database"
  type        = string
  default     = "webappdb"
}