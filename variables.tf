variable "create_function" {
  description = "Controls whether Lambda Function resource should be created"
  type        = bool
  default     = true
}

variable "create_role" {
  description = "Controls whether IAM role for Lambda Function should be created"
  type        = bool
  default     = true
}

###########
# Function
###########

variable "function_name" {
  description = "A unique name for your Lambda Function"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = ""
}

variable "lambda_role" {
  description = " IAM role ARN attached to the Lambda Function. This governs both who / what can invoke your Lambda Function, as well as what resources our Lambda Function has access to. See Lambda Permission Model for more details."
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of your Lambda Function (or Layer)"
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "The ARN of KMS key to use by your Lambda Function"
  type        = string
  default     = null
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 64 MB increments."
  type        = number
  default     = 128
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version."
  type        = bool
  default     = false
}

variable "timeout" {
  description = "The amount of time your Lambda Function has to run in seconds."
  type        = number
  default     = 3
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "vpc_subnet_ids" {
  description = "List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets."
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group ids when Lambda Function should run in the VPC."
  type        = list(string)
  default     = null
}

variable "environment" {
  description = "Environment name."
  type        = string
}

variable "service_name" {
  description = "name of the service to add in tags"
  type = string
}

variable "launched_by" {
  description = "name of the user who is launching the cluster for adding in tags"
  type = string
}

variable "team_name" {
  description = "name of the team to add in tags"
  type = string
}

variable "timeouts" {
  description = "Define maximum timeout for creating, updating, and deleting Lambda Function resources"
  type        = map(string)
  default     = {}
}

variable "package_path" {
  description = "name of the package file to use"
  type = string
  default = null
}

############################################
# Lambda Permissions (for allowed triggers)
############################################

variable "create_current_version_allowed_triggers" {
  description = "Whether to allow triggers on current version of Lambda Function (this will revoke permissions from previous version because Terraform manages only current resources)"
  type        = bool
  default     = true
}

variable "allowed_triggers" {
  description = "Map of allowed triggers to create Lambda permissions"
  type        = map(any)
  default     = {}
}

######
# IAM
######

variable "role_name" {
  description = "Name of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_description" {
  description = "Description of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role to use for Lambda Function"
  type        = string
  default     = null
}

variable "role_force_detach_policies" {
  description = "Specifies to force detaching any policies the IAM role has before destroying it."
  type        = bool
  default     = true
}

variable "role_permissions_boundary" {
  description = "The ARN of the policy that is used to set the permissions boundary for the IAM role used by Lambda Function"
  type        = string
  default     = null
}

variable "role_tags" {
  description = "A map of tags to assign to IAM role"
  type        = map(string)
  default     = {}
}

variable "role_maximum_session_duration" {
  description = "Maximum session duration, in seconds, for the IAM role"
  type        = number
  default     = 3600
}

###########
# Policies
###########

variable "policy_name" {
  description = "IAM policy name. It override the default value, which is the same as role_name"
  type        = string
  default     = null
}

variable "trusted_entities" {
  description = "List of additional trusted entities for assuming Lambda Function role (trust relationship)"
  type        = any
  default     = []
}

variable "assume_role_policy_statements" {
  description = "Map of dynamic policy statements for assuming Lambda Function role (trust relationship)"
  type        = any
  default     = {}
}

variable "attach_policy_json" {
  description = "Controls whether policy_json should be added to IAM role for Lambda Function"
  type        = bool
  default     = false
}

variable "policy_path" {
  description = "Path of policies to that should be added to IAM role for Lambda Function"
  type        = string
  default     = null
}

variable "policy_json" {
  description = "An additional policy document as JSON to attach to the Lambda Function role"
  type        = string
  default     = null
}

variable "attach_network_policy" {
  description = "true is lambda is being created inside vpc"
  type = bool
  default = false
}

################################################################################
# Security Group
################################################################################

variable "create_security_group" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = false
}

variable "security_group_name" {
  description = "Name of VPC security group to associate"
  type        = string
  default     = null
}

variable "security_group_description" {
  description = "Description of VPC security group"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = null
}

variable "security_group_rules" {
  description = "Security group rules to add to the security group created"
  type        = any
  default     = {}
}