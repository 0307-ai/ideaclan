resource "aws_ecr_repository_policy" "this" {
  count = var.create_repository && var.attach_repository_policy ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = var.create_repository_policy ? data.aws_iam_policy_document.repository[0].json : var.repository_policy
}

# Policy used by repositories
data "aws_iam_policy_document" "repository" {
  count = var.create_repository && var.create_repository_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.create_repository_policy ? [1] : []

    content {
      sid = "PrivateReadOnly"

      principals {
        type = "AWS"
        identifiers = coalescelist(
          concat(var.repository_read_access_arns, var.repository_read_write_access_arns),
          ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"],
        )
      }

      actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:DescribeImageScanFindings",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetRepositoryPolicy",
        "ecr:ListImages",
        "ecr:ListTagsForResource",
      ]
    }
  }


  dynamic "statement" {
    for_each = length(var.repository_lambda_read_access_arns) > 0 ? [1] : []

    content {
      sid = "PrivateLambdaReadOnly"

      principals {
        type        = "Service"
        identifiers = ["lambda.amazonaws.com"]
      }

      actions = [
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
      ]

      condition {
        test     = "StringLike"
        variable = "aws:sourceArn"

        values = var.repository_lambda_read_access_arns
      }

    }
  }

  dynamic "statement" {
    for_each = length(var.repository_read_write_access_arns) > 0 ? [var.repository_read_write_access_arns] : []

    content {
      sid = "ReadWrite"

      principals {
        type        = "AWS"
        identifiers = statement.value
      }

      actions = [
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
      ]
    }
  }
}