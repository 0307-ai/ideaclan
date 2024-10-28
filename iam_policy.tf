resource "aws_iam_policy" "policy" {
  count = var.create_custom_policy ? 1 : 0

  name        = var.custom_policy_name
  name_prefix = var.custom_policy_name_prefix
  path        = var.custom_policy_path
  description = var.custom_policy_description

  policy = var.custom_policy

  tags = local.tags
}