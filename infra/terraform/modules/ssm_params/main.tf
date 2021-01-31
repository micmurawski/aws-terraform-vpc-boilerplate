resource "aws_ssm_parameter" "this" {
  for_each = var.params

  name      = each.key
  type      = each.value.type
  value     = each.value.value
  overwrite = true

  tags = var.tags
}
