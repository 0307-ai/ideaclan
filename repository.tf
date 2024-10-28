locals {
  region          = data.aws_region.current.name

  tags = {
    service_name = var.service_name
    team_name    = var.team_name
    environment  = var.environment
    launched_by  = var.launched_by
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

resource "aws_ecr_repository" "this" {
  count = var.create_repository ? 1 : 0

  name                 = var.repository_name
  image_tag_mutability = var.repository_image_tag_mutability

  encryption_configuration {
    encryption_type = var.repository_encryption_type
    kms_key         = var.repository_kms_key
  }

  force_delete = var.repository_force_delete

  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }

  tags = local.tags
}