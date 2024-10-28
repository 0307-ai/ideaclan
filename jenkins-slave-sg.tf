resource "aws_security_group" "jenkins_slave_sg" {
  name        = "${var.environment}-${var.application}-slave-sg"
  description = "Security Group for Instance"
  vpc_id      = var.vpc_id


#   Ingress rule for NLB Security Groups\
  ingress {
    description      = "Traffic from Jenkins Master"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    security_groups = [aws_security_group.jenkins_master_sg.id]
  }

  # Ingress rules for CIDR blocks
  dynamic "ingress" {
    for_each = var.slave_create_ingress_cidr ? toset(range(length(var.slave_ingress_cidr_from_port))) : []
    content {
      from_port   = var.slave_ingress_cidr_from_port[ingress.key]
      to_port     = var.slave_ingress_cidr_to_port[ingress.key]
      protocol    = var.slave_ingress_cidr_protocol[ingress.key]
      cidr_blocks = var.slave_ingress_cidr_block
    }
  }

#   Ingress rules for Security Groups
  dynamic "ingress" {
    for_each = var.slave_create_ingress_sg ? toset(range(length(var.slave_ingress_sg_from_port))) : []
    content {
      from_port       = var.slave_ingress_sg_from_port[ingress.key]
      to_port         = var.slave_ingress_sg_to_port[ingress.key]
      protocol        = var.slave_ingress_sg_protocol[ingress.key]
      security_groups = var.slave_ingress_security_group_ids
    }
  }

  # Egress rules for CIDR blocks
  dynamic "egress" {
    for_each = var.slave_create_egress_cidr ? toset(range(length(var.slave_egress_cidr_from_port))) : []
    content {
      from_port   = var.slave_egress_cidr_from_port[egress.key]
      to_port     = var.slave_egress_cidr_to_port[egress.key]
      protocol    = var.slave_egress_cidr_protocol[egress.key]
      cidr_blocks = var.slave_egress_cidr_block
    }
  }

  # Egress rules for Security Groups
  dynamic "egress" {
    for_each = var.slave_create_egress_sg ? toset(range(length(var.slave_egress_sg_from_port))) : []
    content {
      from_port       = var.slave_egress_sg_from_port[egress.key]
      to_port         = var.slave_egress_sg_to_port[egress.key]
      protocol        = var.slave_egress_sg_protocol[egress.key]
      security_groups = var.slave_egress_security_group_ids
    }
  }

  tags = merge(
    {
      Name        = "${var.environment}-${var.application}-slave-sg"
      Environment = var.environment
      Owner       = var.owner
      Application = var.application
    },
    var.tags
  )

}

output "jenkins-slave-security_group_ids" {
  description = "ID of the security group."
  value       = aws_security_group.jenkins_slave_sg.*.id
}