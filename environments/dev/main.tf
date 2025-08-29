# Add the secrets module
module "secrets" {
  source = "../../modules/secrets"

  environment   = "dev"
  database_name = "webappdb"
}

module "networking" {
  source = "../../modules/networking"

  environment          = "dev"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones   = ["us-east-1a", "us-east-1b"]
}


module "database" {
  source = "../../modules/database"

  environment                = "dev"
  private_subnet_ids         = module.networking.private_subnet_ids
  database_security_group_id = module.networking.database_security_group_id
  database_name              = "webappdb"
  database_secret_arn        = module.secrets.database_secret_arn # Reference the secret ARN
  database_instance_class    = "db.t3.micro"
  database_allocated_storage = 20
  skip_final_snapshot        = true
  deletion_protection        = false
  backup_retention_period    = 0
}

module "compute" {
  source = "../../modules/compute"

  environment           = "dev" # or "prod"
  vpc_id                = module.networking.vpc_id
  public_subnet_ids     = module.networking.public_subnet_ids
  private_subnet_ids    = module.networking.private_subnet_ids
  alb_security_group_id = module.networking.alb_security_group_id
  web_security_group_id = module.networking.web_security_group_id
  db_endpoint           = module.database.db_endpoint
  db_name               = module.database.db_name
  database_secret_arn   = module.secrets.database_secret_arn # Reference the secret ARN
  instance_type         = "t2.micro"
  min_size              = 2
  max_size              = 4
  desired_capacity      = 2
  key_name              = null
}

module "monitoring" {
  source = "../../modules/monitoring"

  environment    = "dev"
  asg_name       = module.compute.asg_name
  db_instance_id = module.database.db_instance_id
}