locals {
  jenkins_slave_asg_tags = merge(
    var.tags,
    { "Name" = "${var.environment}-${var.application}-slave-asg"  }
  )
}

resource "aws_launch_template" "jenkins_slave_lt" {
  name_prefix   = "${var.environment}-${var.application}-slave-launch-template"
  image_id      = var.slave_ami_id
  instance_type = var.slave_instance_type
  key_name      = var.slave_key_name


#IAM_instanceprofile
  iam_instance_profile {
    arn = "arn:aws:iam::891377316540:instance-profile/Jenkins_Master_Role"
  }

#need confirmation
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 500
      volume_type = "gp3"
      delete_on_termination = true
      encrypted = "false"
      #snapshot_id = "snap-094d2fe1140245d43"
    }
  }

  network_interfaces {
    associate_public_ip_address = var.public_access
    security_groups             = [aws_security_group.jenkins_slave_sg.id]
  }

  user_data = base64encode(var.slave_user_data)

}

resource "aws_autoscaling_group" "slave-asg" {
  name                = "${var.environment}-${var.application}-slave-asg"
  capacity_rebalance  = true
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = var.asg_subnets
  protect_from_scale_in = true

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "capacity-optimized"
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.jenkins_slave_lt.id
        version = "$Latest"
      }

      override {
        instance_type     = "t4g.medium"
      }

      override {
        instance_type     = "t4g.large"
      }

      override {
        instance_type     = "t4g.xlarge"
      }

      override {
        instance_type     = "m6g.medium"
      }

      override {
        instance_type     = "m6g.large"
      }

      override {
        instance_type     = "r6g.medium"
      }

      override {
        instance_type     = "r6g.large"
      }

      override {
        instance_type     = "r6g.xlarge"
      }

      override {
        instance_type     = "r7g.medium"
      }

      override {
        instance_type     = "r7g.large"
      }
    }
  }

  dynamic "tag" {
    for_each = local.jenkins_slave_asg_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

}

resource "aws_autoscaling_policy" "cpu_scaling_policy" {
  name                   = "${var.environment}-${var.application}-cpu-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  estimated_instance_warmup = var.instance_warmup_time
  autoscaling_group_name = aws_autoscaling_group.slave-asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.target_value
  }
}


# resource "aws_spot_fleet_request" "jenkins_slave_spot_fleet" {
#   iam_fleet_role  = "arn:aws:iam::537984406465:role/aws-ec2-spot-fleet-tagging-role"
#   target_capacity = 1
#   valid_until     = "2025-11-04T20:44:20Z"

#   launch_template_config {
#     launch_template_specification {
#       id      = aws_launch_template.jenkins_slave_lt.id
#       version = aws_launch_template.jenkins_slave_lt.latest_version
#     }
#     overrides {
#       subnet_id = var.subnet_ids[0]
#     }
#     overrides {
#       subnet_id = var.subnet_ids[1]
#     }
#     overrides {
#       subnet_id = var.subnet_ids[2]
#     }
#   }

  
# }
