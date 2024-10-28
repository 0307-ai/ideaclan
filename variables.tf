variable "region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "rabbitmq_version" {
  description = "The version of RabbitMQ to use"
  default     = "3.12.13"
}

variable "instance_type" {
  description = "The instance type for RabbitMQ broker"
  default     = "mq.m5.large"
}

variable "vpc_id" {
  description = "The VPC ID where the RabbitMQ broker will be created"
  type        = string
}

variable "subnet_ids" {
  description = "The list of subnet IDs for the RabbitMQ broker"
  type        = list(string)
}

variable "environment_name" {
  description = "ENV_NAME"
  type        = string
  
}


# variable "admin_username" {
#   description = "The admin username for RabbitMQ broker"
#   default     = "admin"
# }

# variable "admin_password" {
#   description = "The admin password for RabbitMQ broker"
# }