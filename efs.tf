resource "aws_security_group" "efs_sg" {
  name_prefix = "efs-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [var.ingress_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.egress_cidr_block]
  }
}

resource "aws_efs_file_system" "jenkins" {
  creation_token   = var.creation_token
  encrypted        = var.encrypted
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode
  tags             = var.tags
}

resource "aws_efs_mount_target" "jenkins" {
  count            = length(var.subnet_ids)
  file_system_id   = aws_efs_file_system.jenkins.id
  subnet_id        = var.subnet_ids[count.index]
  security_groups  = [aws_security_group.efs_sg.id]
}

output "efs_id" {
  value = aws_efs_file_system.jenkins.id
}

##### EFS ####

# output "security_group_id" {
#   description = "ID of the security group"
#   value       = aws_security_group.efs_sg.id
# }

# output "efs_file_system_id" {
#   description = "ID of the EFS file system"
#   value       = aws_efs_file_system.jenkins.id
# }

# output "efs_mount_target_ids" {
#   description = "IDs of the EFS mount targets"
#   value       = [for mt in aws_efs_mount_target.jenkins : mt.id]
# }

# output "dns_name" {
#   description = "DNS name of the EFS file system"
#   value       = aws_efs_file_system.jenkins.dns_name
# }

output "efs_security_group_id" {
  description = "The ID of the EFS security group"
  value       = aws_security_group.efs_sg.id
}

output "efs_file_system_id" {
  description = "The ID of the EFS file system"
  value       = aws_efs_file_system.jenkins.id
}

output "efs_mount_target_ids" {
  description = "The IDs of the EFS mount targets"
  value       = [for mt in aws_efs_mount_target.jenkins : mt.id]
}

output "efs_mount_target_ips" {
  description = "The IP addresses of the EFS mount targets"
  value       = [for mt in aws_efs_mount_target.jenkins : mt.ip_address]
}

output "efs_dns_name" {
  description = "The DNS name of the EFS file system"
  value       = format("%s.efs.%s.amazonaws.com", aws_efs_file_system.jenkins.id, var.region)
}

#### EFS Variable ####

#variable "vpc_id" {
#  description = "The VPC ID"
#  type        = string
#}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "ingress_cidr_block" {
  description = "CIDR block for ingress rule"
  type        = string
  default     = "10.0.0.0/16"
}

variable "egress_cidr_block" {
  description = "CIDR block for egress rule"
  type        = string
  default     = "0.0.0.0/0"
}

variable "creation_token" {
  description = "Unique creation token for the EFS file system"
  type        = string
  default     = "jenkins"
}

variable "encrypted" {
  description = "Whether to enable encryption at rest"
  type        = bool
  default     = true
}

variable "performance_mode" {
  description = "Performance mode of the EFS file system"
  type        = string
  default     = "generalPurpose"
}

variable "throughput_mode" {
  description = "Throughput mode for the EFS file system"
  type        = string
  default     = "bursting"
}
