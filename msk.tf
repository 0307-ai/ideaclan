resource "aws_security_group" "msk_security_group" {
  name        = "${var.cluster_name}-security-group"
  description = "Security group for MSK cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 9094 # access from within aws
    to_port     = 9094
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 2181  #zookeeper
    to_port     = 2181
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 2888 #for follower connections
    to_port     = 2888
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  ingress {
    from_port   = 3888 #related to zookeeper
    to_port     = 3888
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Optional: JMX Monitoring port
  ingress {
    from_port   = 9999 
    to_port     = 9999
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_msk_configuration" "msk_configuration" {
  name              = var.config_name
  kafka_versions    = [var.kafka_version]
  server_properties = file("${path.module}/../${var.config_file_path}")
}

resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = var.cluster_name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.number_of_broker_nodes
  broker_node_group_info {
    instance_type   = var.instance_type
    client_subnets  = var.client_subnets
    security_groups = [aws_security_group.msk_security_group.id]
    storage_info {
      ebs_storage_info {
        volume_size = var.ebs_volume_size
      }
    }
  }
  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }
  configuration_info {
    arn      = aws_msk_configuration.msk_configuration.arn
    revision = aws_msk_configuration.msk_configuration.latest_revision
  }
 # zookeeper_connect_string = var.zookeeper_connect_string
}

resource "aws_appautoscaling_target" "msk_target" {
  max_capacity       = 10
  min_capacity       = 2
  resource_id        = "cluster/${aws_msk_cluster.msk_cluster.arn}"
  scalable_dimension = "kafka:broker:StorageVolumeSize"
  service_namespace  = "kafka"
}

resource "aws_appautoscaling_policy" "msk_scale_out_policy" {
  name               = "msk-scale-out"
  resource_id        = aws_appautoscaling_target.msk_target.resource_id
  scalable_dimension = aws_appautoscaling_target.msk_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.msk_target.service_namespace
  policy_type        = "TargetTrackingScaling"
  target_tracking_scaling_policy_configuration {
    target_value       = var.target_value
    predefined_metric_specification {
      predefined_metric_type = var.predefined_metric_type
    }
    scale_out_cooldown  = var.scale_out_cooldown
    scale_in_cooldown   = var.scale_in_cooldown
  }
}

output "msk_cluster_arn" {
  value = aws_msk_cluster.msk_cluster.arn
}

output "msk_cluster_name" {
  value = aws_msk_cluster.msk_cluster.cluster_name
}

