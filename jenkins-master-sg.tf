resource "aws_security_group" "jenkins_master_sg" {
  name        = "${var.environment}-${var.application}-master-sg"
  description = "Security Group for Instance"
  vpc_id      = var.vpc_id

  # Ingress rules for CIDR blocks
  dynamic "ingress" {
    for_each = var.master_create_ingress_cidr ? toset(range(length(var.master_ingress_cidr_from_port))) : []
    content {
      from_port   = var.master_ingress_cidr_from_port[ingress.key]
      to_port     = var.master_ingress_cidr_to_port[ingress.key]
      protocol    = var.master_ingress_cidr_protocol[ingress.key]
      cidr_blocks = var.master_ingress_cidr_block
    }
  }

#   Ingress rule for NLB Security Groups\
  ingress {
    description      = "Traffic from ALB"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

#   Ingress rule for SSH Security Groups\
  ingress {
    description      = "Traffic from ALB"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
  }

#   Ingress rules for Security Groups
  dynamic "ingress" {
    for_each = var.master_create_ingress_sg ? toset(range(length(var.master_ingress_sg_from_port))) : []
    content {
      from_port       = var.master_ingress_sg_from_port[ingress.key]
      to_port         = var.master_ingress_sg_to_port[ingress.key]
      protocol        = var.master_ingress_sg_protocol[ingress.key]
      security_groups = var.master_ingress_security_group_ids
    }
  }

  # Egress rules for CIDR blocks
  dynamic "egress" {
    for_each = var.master_create_egress_cidr ? toset(range(length(var.master_egress_cidr_from_port))) : []
    content {
      from_port   = var.master_egress_cidr_from_port[egress.key]
      to_port     = var.master_egress_cidr_to_port[egress.key]
      protocol    = var.master_egress_cidr_protocol[egress.key]
      cidr_blocks = var.master_egress_cidr_block
    }
  }

  # Egress rules for Security Groups
  dynamic "egress" {
    for_each = var.master_create_egress_sg ? toset(range(length(var.master_egress_sg_from_port))) : []
    content {
      from_port       = var.master_egress_sg_from_port[egress.key]
      to_port         = var.master_egress_sg_to_port[egress.key]
      protocol        = var.master_egress_sg_protocol[egress.key]
      security_groups = var.master_egress_security_group_ids
    }
  }

  tags = merge(
    {
      Name        = "${var.environment}-${var.application}-master-sg"
      Environment = var.environment
      Owner       = var.owner
      Application = var.application
    },
    var.tags
  )

}

output "jenkins-master-security_group_ids" {
  description = "ID of the security group."
  value       = aws_security_group.jenkins_master_sg.*.id
}
