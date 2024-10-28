resource "aws_kms_replica_key" "this" {
  count = var.create_key && var.create_replica ? 1 : 0

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = var.description
  primary_key_arn                    = var.primary_key_arn
  enabled                            = var.is_enabled
  policy                             = coalesce(var.policy, data.aws_iam_policy_document.this[0].json)

  tags = local.tags
}