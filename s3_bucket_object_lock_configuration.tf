resource "aws_s3_bucket_object_lock_configuration" "this" {
  count = local.create_bucket && var.object_lock_enabled && try(var.object_lock_configuration.rule.default_retention, null) != null ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner
  token                 = try(var.object_lock_configuration.token, null)

  rule {
    default_retention {
      mode  = var.object_lock_configuration.rule.default_retention.mode
      days  = try(var.object_lock_configuration.rule.default_retention.days, null)
      years = try(var.object_lock_configuration.rule.default_retention.years, null)
    }
  }
}