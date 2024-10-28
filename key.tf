data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

locals {
  region          = data.aws_region.current.name
  description    = "${local.region}-${var.environment}-${var.description}-key"
  tags = {
    service_name = var.service_name
    team_name    = var.team_name
    environment  = var.environment
    launched_by  = var.launched_by
  }
}

data "aws_region" "current" {}

resource "aws_kms_key" "this" {
  count = var.create_key && !var.create_replica ? 1 : 0

  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  customer_master_key_spec           = var.customer_master_key_spec
  deletion_window_in_days            = var.deletion_window_in_days
  description                        = local.description
  enable_key_rotation                = var.enable_key_rotation
  is_enabled                         = var.is_enabled
  key_usage                          = var.key_usage
  multi_region                       = var.multi_region
  policy                             = coalesce(var.policy, data.aws_iam_policy_document.this[0].json)

  tags = local.tags
}