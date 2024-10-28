resource "aws_lb_target_group" "main" {
  count = var.create_lb ? length(var.target_groups) : 0

  name        = "${local.region}-${var.environment}-${lookup(var.target_groups[count.index], "name", null)}-tg"
  name_prefix = lookup(var.target_groups[count.index], "name_prefix", null)

  vpc_id           = var.vpc_id
  port             = try(var.target_groups[count.index].backend_port, null)
  protocol         = try(upper(var.target_groups[count.index].backend_protocol), null)
  protocol_version = try(upper(var.target_groups[count.index].protocol_version), null)
  target_type      = try(var.target_groups[count.index].target_type, null)

  connection_termination             = try(var.target_groups[count.index].connection_termination, null)
  deregistration_delay               = try(var.target_groups[count.index].deregistration_delay, null)
  slow_start                         = try(var.target_groups[count.index].slow_start, null)
  proxy_protocol_v2                  = try(var.target_groups[count.index].proxy_protocol_v2, false)
  lambda_multi_value_headers_enabled = try(var.target_groups[count.index].lambda_multi_value_headers_enabled, false)
  load_balancing_algorithm_type      = try(var.target_groups[count.index].load_balancing_algorithm_type, null)
  preserve_client_ip                 = try(var.target_groups[count.index].preserve_client_ip, null)
  ip_address_type                    = try(var.target_groups[count.index].ip_address_type, null)
  load_balancing_cross_zone_enabled  = try(var.target_groups[count.index].load_balancing_cross_zone_enabled, null)

  dynamic "health_check" {
    for_each = try([var.target_groups[count.index].health_check], [])

    content {
      enabled             = try(health_check.value.enabled, null)
      interval            = try(health_check.value.interval, null)
      path                = try(health_check.value.path, null)
      port                = try(health_check.value.port, null)
      healthy_threshold   = try(health_check.value.healthy_threshold, null)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, null)
      timeout             = try(health_check.value.timeout, null)
      protocol            = try(health_check.value.protocol, null)
      matcher             = try(health_check.value.matcher, null)
    }
  }

  dynamic "stickiness" {
    for_each = try([var.target_groups[count.index].stickiness], [])

    content {
      enabled         = try(stickiness.value.enabled, null)
      cookie_duration = try(stickiness.value.cookie_duration, null)
      type            = try(stickiness.value.type, null)
      cookie_name     = try(stickiness.value.cookie_name, null)
    }
  }

  tags = merge(
    local.tags,
    {
      "Name" = try(var.target_groups[count.index].name, var.target_groups[count.index].name_prefix, "")
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}