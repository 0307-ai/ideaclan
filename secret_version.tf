resource "aws_secretsmanager_secret_version" "this" {
  count = var.create && !(var.enable_rotation || var.ignore_secret_changes) ? 1 : 0

  secret_id      = aws_secretsmanager_secret.this[0].id
  secret_string  = var.create_random_password ? random_password.this[0].result : var.secret_string
  secret_binary  = var.secret_binary
  version_stages = var.version_stages
}

resource "aws_secretsmanager_secret_version" "ignore_changes" {
  count = var.create && (var.enable_rotation || var.ignore_secret_changes) ? 1 : 0

  secret_id      = aws_secretsmanager_secret.this[0].id
  secret_string  = var.secret_string
  #secret_string  = var.create_random_password ? random_password.this[0].result : var.secret_string
  secret_binary  = var.secret_binary
  version_stages = var.version_stages

  lifecycle {
    ignore_changes = [
      secret_string,
      secret_binary,
      version_stages,
    ]
  }
}

resource "random_password" "this" {
  count = var.create && var.create_random_password ? 1 : 0

  length           = var.random_password_length
  special          = true
  override_special = var.random_password_override_special
}