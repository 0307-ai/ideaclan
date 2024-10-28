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
  default     = true
}

variable "role_name" {
  description = "Name of IAM role"
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
  default     = null
}

variable "role_description" {
  description = "IAM Role description"
  type        = string
  default     = null
}

variable "role_name_prefix" {
  description = "IAM role name prefix"
  type        = string
  default     = null
}

variable "role_policy_arns" {
  description = "ARNs of any policies to attach to the IAM role"
  type        = list(string)
  default     = []
}

variable "oidc_id" {
  description = "OIDC provider arn"
  type        = string
  default     = null
}

variable "service_account_namespace" {
  description = "namespace for which service account is being created"
  type        = string
  default     = null
}

variable "service_account_name" {
  description = "name of the service account"
  type        = string
  default     = null
}

variable "force_detach_policies" {
  description = "Whether policies should be detached from this role when destroying"
  type        = bool
  default     = true
}

variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = null
}

variable "assume_role_condition_test" {
  description = "Name of the [IAM condition operator](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_condition_operators.html) to evaluate when assuming the role"
  type        = string
  default     = "StringEquals"
}

variable "allow_self_assume_role" {
  description = "Determines whether to allow the role to be [assume itself](https://aws.amazon.com/blogs/security/announcing-an-update-to-iam-role-trust-policy-behavior/)"
  type        = bool
  default     = false
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