resource "aws_s3_bucket_metric" "this" {
  for_each = { for k, v in local.metric_configuration : k => v if local.create_bucket }

  name   = each.value.name
  bucket = aws_s3_bucket.this[0].id

  dynamic "filter" {
    for_each = length(try(flatten([each.value.filter]), [])) == 0 ? [] : [true]
    content {
      prefix = try(each.value.filter.prefix, null)
      tags   = try(each.value.filter.tags, null)
    }
  }
}