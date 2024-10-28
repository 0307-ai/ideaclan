data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  create = var.create_function
  region          = data.aws_region.current.name
  function_name    = "${local.region}-${var.environment}-${var.function_name}-function"
  tags = {
    service_name = var.service_name
    team_name    = var.team_name
    environment  = var.environment
    launched_by  = var.launched_by
  }
}

resource "aws_lambda_function" "this" {
  count = var.create_function ? 1 : 0

  function_name                      = local.function_name
  description                        = var.description
  handler                            = var.handler
  memory_size                        = var.memory_size
  role                               = var.create_role ? aws_iam_role.lambda[0].arn : var.lambda_role
  runtime                            = var.runtime
  timeout                            = var.timeout
  filename         = "${path.module}/${var.package_path}"
  publish                            = var.publish
  kms_key_arn                        = var.kms_key_arn

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && (var.vpc_security_group_ids != null || var.create_security_group) ? [true] : []
    content {
      security_group_ids = var.create_security_group ? [aws_security_group.this[0].id] : var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }

  timeouts {
    create = try(var.timeouts.create, null)
    update = try(var.timeouts.update, null)
    delete = try(var.timeouts.delete, null)
  }

  tags = local.tags

  depends_on = [
    aws_iam_role_policy_attachment.additional_json,
  ]
}

resource "aws_lambda_permission" "current_version_triggers" {
  for_each = { for k, v in var.allowed_triggers : k => v if var.create_function  && var.create_current_version_allowed_triggers }

  function_name = aws_lambda_function.this[0].function_name
  # qualifier     = aws_lambda_function.this[0].version

  statement_id       = try(each.value.statement_id, each.key)
  action             = try(each.value.action, "lambda:InvokeFunction")
  principal          = try(each.value.principal, format("%s.amazonaws.com", try(each.value.service, "")))
  principal_org_id   = try(each.value.principal_org_id, null)
  source_arn         = try(each.value.source_arn, null)
  source_account     = try(each.value.source_account, null)
  event_source_token = try(each.value.event_source_token, null)
}