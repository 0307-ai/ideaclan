locals {
  create_role = var.create_function && var.create_role
  role_name   = local.create_role ? coalesce(var.role_name, local.function_name, "*") : null
  policy_name = coalesce(var.policy_name, local.role_name, "*")

  # IAM Role trusted entities is a list of any (allow strings (services) and maps (type+identifiers))
  trusted_entities_services = distinct(compact(concat(
    ["lambda.amazonaws.com"],
    [for service in var.trusted_entities : try(tostring(service), "")]
  )))

  trusted_entities_principals = [
    for principal in var.trusted_entities : {
      type        = principal.type
      identifiers = tolist(principal.identifiers)
    }
    if !can(tostring(principal))
  ]
}

###########
# IAM role
###########

data "aws_iam_policy_document" "assume_role" {
  count = local.create_role ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = local.trusted_entities_services
    }

    dynamic "principals" {
      for_each = local.trusted_entities_principals
      content {
        type        = principals.value.type
        identifiers = principals.value.identifiers
      }
    }
  }

  dynamic "statement" {
    for_each = var.assume_role_policy_statements

    content {
      sid         = try(statement.value.sid, replace(statement.key, "/[^0-9A-Za-z]*/", ""))
      effect      = try(statement.value.effect, null)
      actions     = try(statement.value.actions, null)
      not_actions = try(statement.value.not_actions, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "not_principals" {
        for_each = try(statement.value.not_principals, [])
        content {
          type        = not_principals.value.type
          identifiers = not_principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = try(statement.value.condition, [])
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_role" "lambda" {
  count = local.create_role ? 1 : 0

  name                  = local.role_name
  description           = var.role_description
  path                  = var.role_path
  force_detach_policies = var.role_force_detach_policies
  permissions_boundary  = var.role_permissions_boundary
  assume_role_policy    = data.aws_iam_policy_document.assume_role[0].json
  max_session_duration  = var.role_maximum_session_duration

  tags = merge(local.tags, var.role_tags)
}

###########################
# Additional policy (JSON)
###########################

resource "aws_iam_policy" "additional_json" {
  count = local.create_role && var.attach_policy_json ? 1 : 0

  name   = local.policy_name
  path   = var.policy_path
  policy = var.policy_json
  tags   = local.tags
}

resource "aws_iam_role_policy_attachment" "additional_json" {
  count = local.create_role && var.attach_policy_json ? 1 : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.additional_json[0].arn
}

######
# VPC
######

# Copying AWS managed policy to be able to attach the same policy with multiple roles without overwrites by another function
data "aws_iam_policy" "vpc" {
  count = local.create_role && var.attach_network_policy ? 1 : 0

  arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AWSLambdaENIManagementAccess"
}

resource "aws_iam_policy" "vpc" {
  count = local.create_role && var.attach_network_policy ? 1 : 0

  name   = "${local.policy_name}-vpc"
  path   = var.policy_path
  policy = data.aws_iam_policy.vpc[0].policy
  tags   = local.tags
}

resource "aws_iam_role_policy_attachment" "vpc" {
  count = local.create_role && var.attach_network_policy ? 1 : 0

  role       = aws_iam_role.lambda[0].name
  policy_arn = aws_iam_policy.vpc[0].arn
}