##### IAM policy

output "custom_policy_id" {
  description = "The policy's ID"
  value       = try(aws_iam_policy.policy[0].id, "")
}

output "custom_policy_arn" {
  description = "The ARN assigned by AWS to this policy"
  value       = try(aws_iam_policy.policy[0].arn, "")
}

output "custom_policy_description" {
  description = "The description of the policy"
  value       = try(aws_iam_policy.policy[0].description, "")
}

output "custom_policy_name" {
  description = "The name of the policy"
  value       = try(aws_iam_policy.policy[0].name, "")
}

output "custom_policy_path" {
  description = "The path of the policy in IAM"
  value       = try(aws_iam_policy.policy[0].path, "")
}

output "custom_policy" {
  description = "The policy document"
  value       = try(aws_iam_policy.policy[0].policy, "")
}

##### IAM role

output "iam_role_arn" {
  description = "ARN of IAM role"
  value       = try(aws_iam_role.this[0].arn, "")
}

output "iam_role_name" {
  description = "Name of IAM role"
  value       = try(aws_iam_role.this[0].name, "")
}

output "iam_role_path" {
  description = "Path of IAM role"
  value       = try(aws_iam_role.this[0].path, "")
}

output "iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = try(aws_iam_role.this[0].unique_id, "")
}

output "iam_instance_profile_arn" {
  description = "ARN of IAM instance profile"
  value       = try(aws_iam_instance_profile.this[0].arn, "")
}

output "iam_instance_profile_name" {
  description = "Name of IAM instance profile"
  value       = try(aws_iam_instance_profile.this[0].name, "")
}

output "iam_instance_profile_id" {
  description = "IAM Instance profile's ID."
  value       = try(aws_iam_instance_profile.this[0].id, "")
}

output "iam_instance_profile_path" {
  description = "Path of IAM instance profile"
  value       = try(aws_iam_instance_profile.this[0].path, "")
}

output "role_sts_externalid" {
  description = "STS ExternalId condition value to use with a role"
  value       = var.role_sts_externalid
}