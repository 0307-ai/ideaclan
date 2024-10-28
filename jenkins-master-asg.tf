resource "aws_launch_template" "application_lt" {
  name_prefix   = "${var.environment}-${var.application}-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = "jenkinsMaster_rsa"  # Replace with the name of your key pair

  iam_instance_profile {
    arn = "arn:aws:iam::891377316540:instance-profile/Jenkins_Master_Role"
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 50
      volume_type           = "gp3"
      delete_on_termination = false
      encrypted             = false
      throughput            = 125
      iops                  = 3000
    }
  }

  network_interfaces {
    associate_public_ip_address = var.public_access
    security_groups             = [aws_security_group.jenkins_master_sg.id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    sudo su
    apt install -y nfs-common
    mkdir -p /var/lib/jenkins
    echo 'fs-0a5608d2608cdea65.efs.ap-south-1.amazonaws.com:/ /var/lib/jenkins nfs4 defaults,nfsvers=4.1,_netdev 0 0' | sudo tee -a /etc/fstab
  EOF
  )
}

resource "aws_autoscaling_group" "jenkins_master_asg" {
  name                = "jenkins-asg"
  max_size            = var.max_size
  min_size            = var.min_size
  desired_capacity    = var.desired_capacity
  health_check_type   = "EC2"
  vpc_zone_identifier = var.asg_subnets

  launch_template {
    id      = aws_launch_template.application_lt.id
    version = aws_launch_template.application_lt.latest_version
  }

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }

  # Uncomment if you need to add tags dynamically
  # dynamic "tag" {
  #   for_each = local.jenkins_master_asg_tags
  #   content {
  #     key                 = tag.key
  #     value               = tag.value
  #     propagate_at_launch = true
  #   }
  # }
}

resource "aws_key_pair" "jenkins_master" {
  key_name   = "jenkinsMaster_rsa"
  public_key = file("~/jenkinsMaster_rsa.pub")
}

