resource "aws_s3_bucket_inventory" "this" {
  for_each = { for k, v in var.inventory_configuration : k => v if local.create_bucket }

  name                     = each.key
  bucket                   = try(each.value.bucket, aws_s3_bucket.this[0].id)
  included_object_versions = each.value.included_object_versions
  enabled                  = try(each.value.enabled, true)
  optional_fields          = try(each.value.optional_fields, null)

  destination {
    bucket {
      bucket_arn = try(each.value.destination.bucket_arn, aws_s3_bucket.this[0].arn)
      format     = try(each.value.destination.format, null)
      account_id = try(each.value.destination.account_id, null)
      prefix     = try(each.value.destination.prefix, null)

      dynamic "encryption" {
        for_each = length(try(flatten([each.value.destination.encryption]), [])) == 0 ? [] : [true]

        content {

          dynamic "sse_kms" {
            for_each = each.value.destination.encryption.encryption_type == "sse_kms" ? [true] : []

            content {
              key_id = try(each.value.destination.encryption.kms_key_id, null)
            }
          }

          dynamic "sse_s3" {
            for_each = each.value.destination.encryption.encryption_type == "sse_s3" ? [true] : []

            content {
            }
          }
        }
      }
    }
  }

  schedule {
    frequency = each.value.frequency
  }

  dynamic "filter" {
    for_each = length(try(flatten([each.value.filter]), [])) == 0 ? [] : [true]

    content {
      prefix = try(each.value.filter.prefix, null)
    }
  }
}

# Inventory and analytics destination bucket requires a bucket policy to allow source to PutObjects
# https://docs.aws.amazon.com/AmazonS3/latest/userguide/example-bucket-policies.html#example-bucket-policies-use-case-9
data "aws_iam_policy_document" "inventory_and_analytics_destination_policy" {
  count = local.create_bucket && var.attach_inventory_destination_policy || var.attach_analytics_destination_policy ? 1 : 0

  statement {
    sid    = "destinationInventoryAndAnalyticsPolicy"
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.this[0].arn}/*",
    ]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values = compact(distinct([
        var.inventory_self_source_destination ? aws_s3_bucket.this[0].arn : var.inventory_source_bucket_arn,
        var.analytics_self_source_destination ? aws_s3_bucket.this[0].arn : var.analytics_source_bucket_arn
      ]))
    }

    condition {
      test = "StringEquals"
      values = compact(distinct([
        var.inventory_self_source_destination ? data.aws_caller_identity.current.id : var.inventory_source_account_id,
        var.analytics_self_source_destination ? data.aws_caller_identity.current.id : var.analytics_source_account_id
      ]))
      variable = "aws:SourceAccount"
    }

    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }
}