variable "region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "assume_role_arn" {
  description = "The ARN of the role to assume for the AWS provider"
  type        = string
}

variable "allocated_storage" {
  description = "The allocated storage size for the RDS instance"
  type        = number
}

variable "db_instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create in the RDS instance"
  type        = string
}

# variable "db_username" {
#   description = "The username for the RDS instance"
#   type        = string
# }

# variable "db_password" {
#   description = "The password for the RDS instance"
#   type        = string
# }

variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to associate with the RDS instance"
  type        = list(string)
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "subnet_groupname" {
  description = "A list of subnet IDs for the DB subnet group"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone where the RDS instance will be created."
  type        = string
}
variable "identifier" {
  description = " Identifier will be created."
  type        = string
}



variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
