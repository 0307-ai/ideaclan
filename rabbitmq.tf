# provider "aws" {
#   region = var.region
#   alias  = "rabbitmq"

  #assume_role {
    #role_arn = "arn:aws:iam::058264138708:role/rds-assume-role"
  #}
#}

resource "aws_security_group" "mq_sg" {
  name        = "rmq-sg"
  description = "Security group for AmazonMQ broker"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 5671
    to_port     = 5671
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5672
    to_port     = 5672
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  // Use -1 for all protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_secretsmanager_secret" "rabbitmq_credentials" {
  name = "rabbitmq_credentials"
}

data "aws_secretsmanager_secret_version" "rabbitmq_credentials_version" {
  secret_id = data.aws_secretsmanager_secret.rabbitmq_credentials.id
}

locals {
  rabbitmq_credentials = jsondecode(data.aws_secretsmanager_secret_version.rabbitmq_credentials_version.secret_string)
}

resource "aws_mq_broker" "rabbitmq" {
  broker_name = "rabbitmq-broker"
  engine_type = "RabbitMQ"
  engine_version = var.rabbitmq_version

  deployment_mode = "CLUSTER_MULTI_AZ"
  host_instance_type = var.instance_type
  publicly_accessible = false
  auto_minor_version_upgrade = true

  security_groups = [aws_security_group.mq_sg.id]

  configuration {
    id       = aws_mq_configuration.rabbitmq_configuration.id
    revision = aws_mq_configuration.rabbitmq_configuration.latest_revision
  }

  user {
    username = local.rabbitmq_credentials.username
    password = local.rabbitmq_credentials.password
  }

  logs {
    general = true
  }

  subnet_ids = var.subnet_ids
}

resource "aws_mq_configuration" "rabbitmq_configuration" {
  name           = "rabbitmq-configuration"
  engine_type    = "RabbitMQ"
  engine_version = var.rabbitmq_version

  data = <<EOF
listeners.ssl.default = 5671
listeners.tcp.default = 5672
log.dir = /var/log/rabbitmq
log.file = rabbitmq.log
management.tcp.port = 15672
management.tcp.ip = 0.0.0.0
frame_max = 131072  # Increase frame_max to 128 KB
EOF

  tags = {
    Environment = var.environment_name
  }
}
