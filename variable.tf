variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the alb-asg resources"
}

variable "region" {
  type        = string
  description = "Region of the alb-asg"
}

variable "internal" {
  description = "Whether the load balancer is internal or not"
  type        = bool
}

variable "loadbalancer_type" {
  description = "Load balancer type"
  type        = string
}

variable "alb_subnets" {
  description = "A list of subnet IDs to use for the resources."
  type        = list(string)
}

variable "target_group_port" {
  description = "Target group port"
  type        = number
}

variable "target_group_protocol" {
  description = "Target group protocol"
  type        = string
}

variable "target_type" {
  description = "Target type"
  type        = string
}

variable "load_balancing_algorithm" {
  description = "Specify the load balancing algorithm type"
  type        = string
}

variable "health_check_path" {
  description = "Health check path"
  type        = string
}

variable "health_check_port" {
  description = "Health check port"
  type        = number
}

variable "health_check_protocol" {
  description = "Health check protocol"
  type        = string
}

variable "health_check_interval" {
  description = "Health check interval"
  type        = number
}

variable "health_check_timeout" {
  description = "Health check timeout"
  type        = number
}

variable "health_check_healthy_threshold" {
  description = "Health check healthy threshold"
  type        = number
}

variable "health_check_unhealthy_threshold" {
  description = "Health check unhealthy threshold"
  type        = number
}

# variable "listener_port" {
#   description = "Listener port"
#   type        = number
# }

# variable "listener_protocol" {
#   description = "Listener protocol"
#   type        = string
# }

# variable "listener_type" {
#   description = "Listener type"
#   type        = string
# }

variable "iam_role" {
  description = "IAM role for the instance"
  type        = string
}


variable "ami_id" {
  type        = string
  description = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instances."
}

variable "slave_ami_id" {
  type        = string
  description = "The ID of the Amazon Machine Image (AMI) to use for the EC2 instances."
}

variable "instance_type" {
  type        = string
  description = "The type of EC2 instance to use for the ASG."
}

variable "slave_instance_type" {
  type        = string
  description = "The type of EC2 instance to use for the ASG."
}

variable "key_name" {
  type        = string
  description = "The name of the EC2 key pair to use for the instances."
}

variable "slave_key_name" {
  type        = string
  description = "The name of the EC2 key pair to use for the instances."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC to use for the resources."
}

variable "asg_subnets" {
  description = "A list of subnet IDs to use for the resources."
  type        = list(string)
}

variable "public_access" {
  description = "Whether the instance is public or not"
  type        = bool
}

#variable "user_data" {
#  description = "user data script"
#  type        = string
#}

variable "slave_user_data" {
  description = "user data script"
  type        = string
}

variable "max_size" {
  description = "Maximum size of something"
  type        = number
}

variable "min_size" {
  description = "Minimum size of something"
  type        = number
}

variable "desired_capacity" {
  description = "Desired capacity of something"
  type        = number
}

variable "propagate_at_launch" {
  description = "To enable ot disable propagate_at_launch"
  type        = bool
}

variable "owner" {
  type        = string
  description = "Name of owner"
}

variable "environment" {
  type        = string
  description = "The environment name for the resources."
}

variable "application" {
  type        = string
  description = "Name of the application"
}

variable "slave_ingress_cidr_block" {
  type        = list(string)
  description = "CIDR blocks for the security group ingress rules"
}

variable "slave_ingress_cidr_from_port" {
  description = "The starting port for ingress rules"
  type        = list(number)
}

variable "slave_ingress_cidr_to_port" {
  description = "The ending port for ingress rules"
  type        = list(number)
}

variable "slave_ingress_cidr_protocol" {
  description = "The protocol for ingress rules"
  type        = list(any)
}

variable "slave_create_ingress_cidr" {
  description = "Whether to create the ingress cidr or not"
  type        = bool
}

variable "slave_ingress_sg_from_port" {
  type        = list(number)
  description = "List of starting ports for sg ingress rules"
}

variable "slave_ingress_sg_to_port" {
  type        = list(number)
  description = "List of ending ports for sg ingress rules"
}

variable "slave_ingress_sg_protocol" {
  type        = list(any)
  description = "List of protocols for sg ingress rules"
}

variable "slave_ingress_security_group_ids" {
  type        = list(string)
  default     = [ "sg-024910ee43fb3c1b9" ]
  description = "List of Security Group ids for sg ingress rules"
}

variable "slave_create_ingress_sg" {
  type        = bool
  description = "Enable or disable Security Groups ingress rules."
}

variable "slave_egress_cidr_block" {
  type        = list(string)
  description = "CIDR blocks for group egress rules"
}

variable "slave_egress_cidr_from_port" {
  description = "The starting port for egress rules"
  type        = list(number)
}

variable "slave_egress_cidr_to_port" {
  description = "The ending port for egress rules"
  type        = list(number)
}

variable "slave_egress_cidr_protocol" {
  description = "The protocol for egress rules"
  type        = list(any)
}

variable "slave_create_egress_cidr" {
  type        = bool
  description = "Enable or disable CIDR block egress rules."
}



variable "slave_egress_sg_from_port" {
  description = "The starting port for egress rules"
  type        = list(number)
}

variable "slave_egress_sg_to_port" {
  description = "The ending port for egress rules"
  type        = list(number)
}

variable "slave_egress_sg_protocol" {
  description = "The protocol for egress rules"
  type        = list(any)
}

variable "slave_egress_security_group_ids" {
  type        = list(string)
  default     = [ "sg-07c9ac859476c9264" ]
  description = "List of Security Group ids for sg egress rules"
}

variable "slave_create_egress_sg" {
  type        = bool
  description = "Enable or disable CIDR block egress rules."
  #default     = "0.0.0.0/0"
}

variable "master_ingress_cidr_block" {
  type        = list(string)
  description = "CIDR blocks for the security group ingress rules"
  #default     = "0.0.0.0/0"
}

variable "master_ingress_cidr_from_port" {
  description = "The starting port for ingress rules"
  type        = list(number)
}

variable "master_ingress_cidr_to_port" {
  description = "The ending port for ingress rules"
  type        = list(number)
}

variable "master_ingress_cidr_protocol" {
  description = "The protocol for ingress rules"
  type        = list(any)
}

variable "master_create_ingress_cidr" {
  description = "Whether to create the ingress cidr or not"
  type        = bool
}

variable "master_ingress_sg_from_port" {
  type        = list(number)
  description = "List of starting ports for sg ingress rules"
}

variable "master_ingress_sg_to_port" {
  type        = list(number)
  description = "List of ending ports for sg ingress rules"
}

variable "master_ingress_sg_protocol" {
  type        = list(any)
  description = "List of protocols for sg ingress rules"
}

variable "master_ingress_security_group_ids" {
  type        = list(string)
  default     = [ "sg-02e874b53d4a6acd7" ]
  description = "List of Security Group ids for sg ingress rules"
}

variable "master_create_ingress_sg" {
  type        = bool
  description = "Enable or disable Security Groups ingress rules."
}

variable "master_egress_cidr_block" {
  type        = list(string)
  description = "CIDR blocks for group egress rules"
}

variable "master_egress_cidr_from_port" {
  description = "The starting port for egress rules"
  type        = list(number)
}

variable "master_egress_cidr_to_port" {
  description = "The ending port for egress rules"
  type        = list(number)
}

variable "master_egress_cidr_protocol" {
  description = "The protocol for egress rules"
  type        = list(any)
}

variable "master_create_egress_cidr" {
  type        = bool
  description = "Enable or disable CIDR block egress rules."
}

variable "master_egress_sg_from_port" {
  description = "The starting port for egress rules"
  type        = list(number)
}

variable "master_egress_sg_to_port" {
  description = "The ending port for egress rules"
  type        = list(number)
}

variable "master_egress_sg_protocol" {
  description = "The protocol for egress rules"
  type        = list(any)
}

variable "master_egress_security_group_ids" {
  type        = list(string)
  default     = [ "sg-0d71726a7bdcd0150" ]
  description = "List of Security Group ids for sg egress rules"
}

variable "master_create_egress_sg" {
  type        = bool
  description = "Enable or disable CIDR block egress rules."
}


variable "alb_ingress_cidr_block" {
  type        = list(string)
  description = "CIDR blocks for the security group ingress rules"
}

variable "alb_ingress_cidr_from_port" {
  description = "The starting port for ingress rules"
  type        = list(number)
}

variable "alb_ingress_cidr_to_port" {
  description = "The ending port for ingress rules"
  type        = list(number)
}

variable "alb_ingress_cidr_protocol" {
  description = "The protocol for ingress rules"
  type        = list(any)
}

variable "alb_create_ingress_cidr" {
  description = "Whether to create the ingress cidr or not"
  type        = bool
}

variable "alb_ingress_sg_from_port" {
  type        = list(number)
  description = "List of starting ports for sg ingress rules"
}

variable "alb_ingress_sg_to_port" {
  type        = list(number)
  description = "List of ending ports for sg ingress rules"
}

variable "alb_ingress_sg_protocol" {
  type        = list(any)
  description = "List of protocols for sg ingress rules"
}

variable "alb_create_ingress_sg" {
  type        = bool
  description = "Enable or disable Security Groups ingress rules."
}

variable "alb_egress_cidr_block" {
  type        = list(string)
  description = "CIDR blocks for the security group egress rules"
}

variable "alb_egress_cidr_from_port" {
  description = "The starting port for egress rules"
  type        = list(number)
}

variable "alb_egress_cidr_to_port" {
  description = "The ending port for egress rules"
  type        = list(number)
}

variable "alb_egress_cidr_protocol" {
  description = "The protocol for egress rules"
  type        = list(any)
}

variable "alb_create_egress_cidr" {
  type        = bool
  description = "Enable or disable CIDR block egress rules."
}

variable "alb_egress_sg_from_port" {
  description = "The starting port for egress rules"
  type        = list(number)
}

variable "alb_egress_sg_to_port" {
  description = "The ending port for egress rules"
  type        = list(number)
}

variable "alb_egress_sg_protocol" {
  description = "The protocol for egress rules"
  type        = list(any)
}

variable "alb_create_egress_sg" {
  type        = bool
  description = "Enable or disable CIDR block egress rules."
}

variable "instance_warmup_time" {
  description = "Time required to warm up a new instance"
  type        = number
}

variable "target_value" {
  description = "Threshold value of asg to start scaling"
  type        = number
}





variable "listener_port" {
  description = "The port on which the listener listens"
  type        = number
}

variable "listener_protocol" {
  description = "The protocol used by the listener"
  type        = string
}


variable "listener_type" {
  description = "Description of your listener_type variable"
  default     = "alb_listener"
}





