resource "aws_ecr_registry_scanning_configuration" "this" {
  count = var.create_repository && var.manage_registry_scanning_configuration ? 1 : 0

  scan_type = var.registry_scan_type

  dynamic "rule" {
    for_each = var.registry_scan_rules

    content {
      scan_frequency = rule.value.scan_frequency

      repository_filter {
        filter      = rule.value.filter
        filter_type = try(rule.value.filter_type, "WILDCARD")
      }
    }
  }
}