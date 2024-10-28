resource "aws_wafv2_web_acl_association" "this" {
  count        = var.web_acl_arn != null ? 1 : 0
  resource_arn = aws_lb.this[0].arn
  web_acl_arn  = var.web_acl_arn
}