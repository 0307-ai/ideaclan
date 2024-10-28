# provider "aws" {
#   region = var.region
#   alias  = "rds_instance"
#   assume_role {
#     role_arn = var.assume_role_arn
#   }
# }


# resource "aws_db_subnet_group" "default" {
#   name       = var.subnet_groupname
#   subnet_ids = var.subnet_ids

  # tags = {
  #   Name = "DB subnet group"
    
    # }
    
    
    
    
     
# data "aws_db_subnet_group" "subnetgroup" {
#   name = var.subnet_groupname
  
# }


  # provisioner "local-exec" {
  #   command = "sleep 60" # Wait for 30 seconds (adjust as necessary)
  # }


# resource "null_resource" "wait_for_subnet_group" {
#   depends_on = [aws_db_subnet_group.default]

#   }

data "aws_secretsmanager_secret" "rds_db_credentials" {
  name = "rds_db_credentials"
}

data "aws_secretsmanager_secret_version" "rds_db_credentials_version" {
  secret_id = data.aws_secretsmanager_secret.rds_db_credentials.id
}

locals {
  rds_credentials = jsondecode(data.aws_secretsmanager_secret_version.rds_db_credentials_version.secret_string)
}

resource "aws_db_parameter_group" "default_postgresql" {
  name        = "default-postgresql-parameter-group"
  family      = "postgres16"
  description = "Default parameter group for PostgreSQL 13"
}

resource "aws_db_instance" "postgresql" {
  allocated_storage       = var.allocated_storage
  engine                  = "postgres"
  engine_version          = "16.3"
  instance_class          = var.db_instance_class
  db_name                 = var.db_name
  identifier              = var.identifier
  username                = local.rds_credentials.username
  password                = local.rds_credentials.password
  parameter_group_name     = aws_db_parameter_group.default_postgresql.name
  publicly_accessible     = false
  vpc_security_group_ids  = var.vpc_security_group_ids
  db_subnet_group_name    = aws_db_subnet_group.default.name
 

  backup_retention_period = 7
  backup_window           = "06:00-09:00"
  maintenance_window      = "Mon:04:00-Mon:05:00"
  apply_immediately       = true
  storage_encrypted       = true
  # monitoring_interval     = 60
  enabled_cloudwatch_logs_exports = ["postgresql"]
  deletion_protection     = true
  availability_zone       = var.availability_zone


  # depends_on = [aws_db_subnet_group.default]
}

resource "aws_security_group" "allow_postgresql" {
  name_prefix = "allow_postgresql"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_postgresql"
  }
}
