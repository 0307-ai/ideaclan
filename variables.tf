##### IAM policy

variable "create_custom_policy" {
  description = "Whether to create the IAM policy"
  type        = bool
  default     = true
}

variable "custom_policy_name" {
  description = "The name of the policy"
  type        = string
  default     = null
}

variable "custom_policy_name_prefix" {
  description = "IAM policy name prefix"
  type        = string
  default     = null
}

variable "custom_policy_path" {
  description = "The path of the policy in IAM"
  type        = string
  default     = "/"
}

variable "custom_policy_description" {
  description = "The description of the policy"
  type        = string
  default     = "IAM Policy"
}

variable "custom_policy" {
  description = "The path of the policy in IAM (tpl file)"
  type        = string
  default     = ""
}

##### IAM role

variable "create_role" {
  description = "Whether to create a role"
  type        = bool
  default     = false
}

variable "trusted_role_actions" {
  description = "Additional trusted role actions"
  type        = list(string)
  default     = ["sts:AssumeRole", "sts:TagSession"]
}

variable "trusted_role_arns" {
  description = "ARNs of AWS entities who can assume these roles"
  type        = list(string)
  default     = []
}

variable "trusted_role_services" {
  description = "AWS Services that can assume these roles"
  type        = list(string)
  default     = []
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = 3600
}

variable "create_instance_profile" {
  description = "Whether to create an instance profile"
  type        = bool
  default     = false
}

variable "role_name" {
  description = "IAM role name"
  type        = string
  default     = null
}

variable "role_path" {
  description = "Path of IAM role"
  type        = string
  default     = "/"
}

variable "role_permissions_boundary_arn" {
  description = "Permissions boundary ARN to use for IAM role"
  type        = string
  default     = ""
}

variable "custom_role_policy_arns" {
  description = "List of ARNs of IAM policies to attach to IAM role"
  type        = list(string)
  default     = []
}

variable "custom_role_trust_policy" {
  description = "A custom role trust policy"
  type        = string
  default     = ""
}

variable "force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = false
}

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = ""
}

variable "role_sts_externalid" {
  description = "STS ExternalId condition values to use with a role (when MFA is not required)"
  type        = any
  default     = []
}

variable "allow_self_assume_role" {
  description = "Determines whether to allow the role to be [assume itself](https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/)"
  type        = bool
  default     = false
}

variable "role_requires_session_name" {
  description = "Determines if the role-session-name variable is needed when assuming a role(https://aws.amazon.com/blogs/security/easily-control-naming-individual-iam-role-sessions/)"
  type        = bool
  default     = false
}

variable "role_session_name" {
  description = "role_session_name for roles which require this parameter when being assumed. By default, you need to set your own username as role_session_name"
  type        = list(string)
  default     = ["$${aws:username}"]
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