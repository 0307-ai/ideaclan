resource "aws_ecr_lifecycle_policy" "this" {
  count = var.create_repository && var.create_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = var.repository_lifecycle_policy
}