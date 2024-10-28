resource "aws_security_group" "security_group" {
  name        = var.cluster_id
  description = "Security group for ${var.cluster_id}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # replace with your VPC's CIDR block
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_id}-sg"
  }
}

resource "aws_elasticache_subnet_group" "subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "redis-subnet-group"
  }
}

resource "aws_elasticache_parameter_group" "parameter_group" { 
  name        = var.parameter_group_name
  family      = "redis6.x"
  description = "parameter group for redis"

  parameter {
    name  = "activerehashing"
    value = "yes"
  }

  parameter {
    name  = "client-output-buffer-limit-normal-hard-limit"
    value = "0"
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/elasticache/${var.cluster_id}"
}

resource "aws_elasticache_replication_group" "cluster" {
  replication_group_id          = var.cluster_id
  description                   = "replication group" 
  engine                        = var.elasticache_engine
  node_type                     = var.node_type
  num_cache_clusters            = var.num_cache_nodes
  parameter_group_name          = aws_elasticache_parameter_group.parameter_group.name
  engine_version                = var.elasticache_engine_version
  port                          = var.port
  subnet_group_name             = aws_elasticache_subnet_group.subnet_group.name
  security_group_ids            = [aws_security_group.security_group.id]
  maintenance_window            = var.maintenance_window
  snapshot_window               = var.snapshot_window
  snapshot_retention_limit      = var.snapshot_retention_limit
  automatic_failover_enabled    = var.automatic_failover_enabled
  at_rest_encryption_enabled    = var.at_rest_encryption_enabled
  transit_encryption_enabled    = var.transit_encryption_enabled
  apply_immediately             = var.apply_immediately

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.log_group.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "slow-log"
  }
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.log_group.name
    destination_type = "cloudwatch-logs"
    log_format       = "json"
    log_type         = "engine-log"
  }
}

resource "aws_sns_topic" "alarm_sns_topic" {
  name         = "${var.cluster_id}-alarms"
  display_name = "Alarms for ${var.cluster_id}"
}

resource "aws_cloudwatch_metric_alarm" "alarm_cpu" {
  alarm_name          = "${var.cluster_id}-cpu-high"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ElastiCache"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric checks CPU utilization"
  alarm_actions       = [aws_sns_topic.alarm_sns_topic.arn]
  
  dimensions = {
    CacheClusterId = aws_elasticache_replication_group.cluster.replication_group_id
  }
}

resource "aws_cloudwatch_metric_alarm" "alarm_memory" {
  alarm_name          = "${var.cluster_id}-memory-low"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeableMemory"
  namespace           = "AWS/ElastiCache"
  period              = 120
  statistic           = "Average"
  threshold           = 50000000 # 50 MB
  alarm_description   = "This metric checks freeable memory"
  alarm_actions       = [aws_sns_topic.alarm_sns_topic.arn]
  
  dimensions = {
    CacheClusterId = aws_elasticache_replication_group.cluster.replication_group_id
  }
}
