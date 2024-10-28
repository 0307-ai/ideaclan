resource "aws_s3_bucket_request_payment_configuration" "this" {
  count = local.create_bucket && var.request_payer != null ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  # Valid values: "BucketOwner" or "Requester"
  payer = lower(var.request_payer) == "requester" ? "Requester" : "BucketOwner"
}