resource "aws_secretsmanager_secret_rotation" "this" {
  count = var.create && var.enable_rotation ? 1 : 0

  rotation_lambda_arn = var.rotation_lambda_arn

  dynamic "rotation_rules" {
    for_each = [var.rotation_rules]

    content {
      automatically_after_days = try(rotation_rules.value.automatically_after_days, null)
      duration                 = try(rotation_rules.value.duration, null)
      schedule_expression      = try(rotation_rules.value.schedule_expression, null)
    }
  }

  secret_id = aws_secretsmanager_secret.this[0].id
}