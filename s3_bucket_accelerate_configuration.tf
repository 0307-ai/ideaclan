resource "aws_s3_bucket_accelerate_configuration" "this" {
  count = local.create_bucket && var.acceleration_status != null ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  # Valid values: "Enabled" or "Suspended"
  status = title(lower(var.acceleration_status))
}