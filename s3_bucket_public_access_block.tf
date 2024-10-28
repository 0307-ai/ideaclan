resource "aws_s3_bucket_public_access_block" "this" {
  count = local.create_bucket && var.attach_public_policy ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}