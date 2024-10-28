data "aws_instances" "jenkins_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [aws_autoscaling_group.jenkins_master_asg.name]
  }

  depends_on = [aws_autoscaling_group.jenkins_master_asg]
}

# Ensure instance IDs are unique and can be referenced easily
locals {
  instance_ids_map = { for id in data.aws_instances.jenkins_instances.ids : id => id }
}

resource "aws_lb" "jenkins_alb" {
  name               = "jenkins-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.alb_subnets
  security_groups    = [aws_security_group.alb_sg.id]

  enable_deletion_protection = false

  tags = merge(
    {
      Name        = "${var.environment}-${var.application}-alb"
      Environment = var.environment
      Owner       = var.owner
      Application = var.application
    },
    var.tags
  )
}

resource "aws_lb_target_group" "jenkins_alb_tg" {
  name     = "jenkins-alb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    path                = "/login"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

resource "aws_lb_target_group_attachment" "jenkins_alb_target_group_attachment" {
  for_each          = local.instance_ids_map
  target_group_arn  = aws_lb_target_group.jenkins_alb_tg.arn
  target_id         = each.key
  port              = 8080
}

resource "aws_lb_listener" "alb-jenkins-master-listener" {
  load_balancer_arn = aws_lb.jenkins_alb.arn
  port              = "8080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins_alb_tg.arn
  }
}

