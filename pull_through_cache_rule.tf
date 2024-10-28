resource "aws_ecr_pull_through_cache_rule" "this" {
  for_each = { for k, v in var.registry_pull_through_cache_rules : k => v if var.create_repository }

  ecr_repository_prefix = each.value.ecr_repository_prefix
  upstream_registry_url = each.value.upstream_registry_url
}