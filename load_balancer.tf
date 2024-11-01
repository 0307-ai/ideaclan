locals {
  lb_name    = "${local.region}-${var.environment}-${var.lb_name}-${var.load_balancer_type}"
  region          = data.aws_region.current.name

  tags = {
    service_name = var.service_name
    team_name    = var.team_name
    environment  = var.environment
    launched_by  = var.launched_by
  }
}

data "aws_region" "current" {}

resource "aws_lb" "this" {
  count = var.create_lb ? 1 : 0

  name        = local.lb_name
  name_prefix = var.name_prefix

  load_balancer_type = var.load_balancer_type
  internal           = var.internal
  security_groups    = var.create_security_group && var.load_balancer_type == "application" ? concat([aws_security_group.this[0].id], var.security_groups) : var.security_groups
  subnets            = var.subnets

  idle_timeout                                = var.idle_timeout
  enable_cross_zone_load_balancing            = var.enable_cross_zone_load_balancing
  enable_deletion_protection                  = var.enable_deletion_protection
  enable_http2                                = var.enable_http2
  enable_tls_version_and_cipher_suite_headers = var.enable_tls_version_and_cipher_suite_headers
  enable_xff_client_port                      = var.enable_xff_client_port
  ip_address_type                             = var.ip_address_type
  drop_invalid_header_fields                  = var.drop_invalid_header_fields
  preserve_host_header                        = var.preserve_host_header
  enable_waf_fail_open                        = var.enable_waf_fail_open
  desync_mitigation_mode                      = var.desync_mitigation_mode
  xff_header_processing_mode                  = var.xff_header_processing_mode

  dynamic "access_logs" {
    for_each = length(var.access_logs) > 0 ? [var.access_logs] : []

    content {
      enabled = try(access_logs.value.enabled, try(access_logs.value.bucket, null) != null)
      bucket  = try(access_logs.value.bucket, null)
      prefix  = try(access_logs.value.prefix, null)
    }
  }

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping

    content {
      subnet_id            = subnet_mapping.value.subnet_id
      allocation_id        = lookup(subnet_mapping.value, "allocation_id", null)
      private_ipv4_address = lookup(subnet_mapping.value, "private_ipv4_address", null)
      ipv6_address         = lookup(subnet_mapping.value, "ipv6_address", null)
    }
  }

  tags = merge(
    {
      Name = (local.lb_name != null) ? local.lb_name : var.name_prefix
    },
    local.tags
  )

  timeouts {
    create = var.load_balancer_create_timeout
    update = var.load_balancer_update_timeout
    delete = var.load_balancer_delete_timeout
  }
}