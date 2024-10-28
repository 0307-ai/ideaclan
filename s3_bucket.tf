data "aws_region" "current" {}
data "aws_canonical_user_id" "this" {
  count = local.create_bucket && local.create_bucket_acl && try(var.owner["id"], null) == null ? 1 : 0
}

data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}
locals {
  create_bucket = var.create_bucket
  region          = data.aws_region.current.name
  bucket    = "${local.region}-${var.environment}-${var.bucket}"
  create_bucket_acl = (var.acl != null && var.acl != "null") || length(local.grants) > 0

  attach_policy = var.attach_require_latest_tls_policy || var.attach_access_log_delivery_policy || var.attach_elb_log_delivery_policy || var.attach_lb_log_delivery_policy || var.attach_deny_insecure_transport_policy || var.attach_inventory_destination_policy || var.attach_deny_incorrect_encryption_headers || var.attach_deny_incorrect_kms_key_sse || var.attach_deny_unencrypted_object_uploads || var.attach_policy

  # Variables with type `any` should be jsonencode()'d when value is coming from Terragrunt
  grants               = try(jsondecode(var.grant), var.grant)
  cors_rules           = try(jsondecode(var.cors_rule), var.cors_rule)
  lifecycle_rules      = try(jsondecode(var.lifecycle_rule), var.lifecycle_rule)
  intelligent_tiering  = try(jsondecode(var.intelligent_tiering), var.intelligent_tiering)
  metric_configuration = try(jsondecode(var.metric_configuration), var.metric_configuration)
  tags = {
    service_name = var.service_name
    team_name    = var.team_name
    environment  = var.environment
    launched_by  = var.launched_by
  }
}

resource "aws_s3_bucket" "this" {
  count = local.create_bucket ? 1 : 0

  bucket        = local.bucket
  bucket_prefix = var.bucket_prefix

  force_destroy       = var.force_destroy
  object_lock_enabled = var.object_lock_enabled
  tags                = local.tags
}