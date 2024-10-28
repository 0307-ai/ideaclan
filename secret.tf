locals {
  region          = data.aws_region.current.name
  name    = "${local.region}-${var.environment}-${var.name}-secret"
  tags = {
    service_name = var.service_name
    team_name    = var.team_name
    environment  = var.environment
    launched_by  = var.launched_by
  }
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_secretsmanager_secret" "this" {
  count = var.create ? 1 : 0

  description                    = var.description
  force_overwrite_replica_secret = var.force_overwrite_replica_secret
  kms_key_id                     = var.kms_key_id
  name                           = local.name
  name_prefix                    = var.name_prefix
  recovery_window_in_days        = var.recovery_window_in_days

  dynamic "replica" {
    for_each = var.replica

    content {
      kms_key_id = try(replica.value.kms_key_id, null)
      region     = try(replica.value.region, replica.key)
    }
  }

  tags = local.tags
}