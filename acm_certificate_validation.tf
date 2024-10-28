locals {
  create_certificate          = var.create_certificate
  create_route53_records_only = var.create_route53_records_only

  distinct_domain_names = coalescelist(var.distinct_domain_names, distinct(
    [for s in concat([var.domain_name], var.subject_alternative_names) : replace(s, "*.", "")]
  ))

  validation_domains = local.create_certificate || local.create_route53_records_only ? distinct(
    [for k, v in try(aws_acm_certificate.this[0].domain_validation_options, var.acm_certificate_domain_validation_options) : merge(
      tomap(v), { domain_name = replace(v.domain_name, "*.", "") }
    )]
  ) : []
}

resource "aws_acm_certificate_validation" "this" {
  count = local.create_certificate && var.validation_method != "NONE" && var.validate_certificate && var.wait_for_validation ? 1 : 0

  certificate_arn = aws_acm_certificate.this[0].arn

  validation_record_fqdns = flatten([aws_route53_record.validation[*].fqdn, var.validation_record_fqdns])

  timeouts {
    create = var.validation_timeout
  }
}

resource "aws_route53_record" "validation" {
  count = (local.create_certificate || local.create_route53_records_only) && var.validation_method == "DNS" && var.create_route53_records && (var.validate_certificate || local.create_route53_records_only) ? length(local.distinct_domain_names) : 0

  zone_id = var.zone_id
  name    = element(local.validation_domains, count.index)["resource_record_name"]
  type    = element(local.validation_domains, count.index)["resource_record_type"]
  ttl     = var.dns_ttl

  records = [
    element(local.validation_domains, count.index)["resource_record_value"]
  ]

  allow_overwrite = var.validation_allow_overwrite_records

  depends_on = [aws_acm_certificate.this]
}