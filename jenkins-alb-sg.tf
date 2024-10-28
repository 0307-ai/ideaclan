resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-${var.application}-alb-sg"
  description = "Security Group for Network Load Balancer"
  vpc_id      = var.vpc_id

  # Ingress rules for CIDR blocks
  dynamic "ingress" {
    for_each = var.alb_create_ingress_cidr ? toset(range(length(var.alb_ingress_cidr_from_port))) : []
    content {
      from_port   = var.alb_ingress_cidr_from_port[ingress.key]
      to_port     = var.alb_ingress_cidr_to_port[ingress.key]
      protocol    = var.alb_ingress_cidr_protocol[ingress.key]
      cidr_blocks = var.alb_ingress_cidr_block
    }
  }

  #Ingress rules for Security Groups
  dynamic "ingress" {
    for_each = var.alb_create_ingress_sg ? toset(range(length(var.alb_ingress_sg_from_port))) : []
    content {
      from_port       = var.alb_ingress_sg_from_port[ingress.key]
      to_port         = var.alb_ingress_sg_to_port[ingress.key]
      protocol        = var.alb_ingress_sg_protocol[ingress.key]
      #security_groups = var.alb_ingress_security_group_ids
    }
  }

  # Egress rules for CIDR blocks
  dynamic "egress" {
    for_each = var.alb_create_egress_cidr ? toset(range(length(var.alb_egress_cidr_from_port))) : []
    content {
      from_port   = var.alb_egress_cidr_from_port[egress.key]
      to_port     = var.alb_egress_cidr_to_port[egress.key]
      protocol    = var.alb_egress_cidr_protocol[egress.key]
      cidr_blocks = var.alb_egress_cidr_block
    }
  }

  # Egress rules for Security Groups
  dynamic "egress" {
    for_each = var.alb_create_egress_sg ? toset(range(length(var.alb_egress_sg_from_port))) : []
    content {
      from_port       = var.alb_egress_sg_from_port[egress.key]
      to_port         = var.alb_egress_sg_to_port[egress.key]
      protocol        = var.alb_egress_sg_protocol[egress.key]
      #security_groups = var.alb_egress_security_group_ids
    }
  }

  tags = merge(
    {
      Name        = "${var.environment}-${var.application}-alb-sg"
      Environment = var.environment
      Owner       = var.owner
      Application = var.application
    },
    var.tags
  )

}

output "jenkins-master-alb-security_group_ids" {
  description = "ID of the security group."
  value       = aws_security_group.alb_sg.*.id
}
