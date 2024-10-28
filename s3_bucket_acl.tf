resource "aws_s3_bucket_acl" "this" {
  count = local.create_bucket && local.create_bucket_acl ? 1 : 0

  bucket                = aws_s3_bucket.this[0].id
  expected_bucket_owner = var.expected_bucket_owner

  # hack when `null` value can't be used (eg, from terragrunt, https://github.com/gruntwork-io/terragrunt/pull/1367)
  acl = var.acl == "null" ? null : var.acl

  dynamic "access_control_policy" {
    for_each = length(local.grants) > 0 ? [true] : []

    content {
      dynamic "grant" {
        for_each = local.grants

        content {
          permission = grant.value.permission

          grantee {
            type          = grant.value.type
            id            = try(grant.value.id, null)
            uri           = try(grant.value.uri, null)
            email_address = try(grant.value.email, null)
          }
        }
      }

      owner {
        id           = try(var.owner["id"], data.aws_canonical_user_id.this[0].id)
        display_name = try(var.owner["display_name"], null)
      }
    }
  }

  # This `depends_on` is to prevent "AccessControlListNotSupported: The bucket does not allow ACLs."
  depends_on = [aws_s3_bucket_ownership_controls.this]
}