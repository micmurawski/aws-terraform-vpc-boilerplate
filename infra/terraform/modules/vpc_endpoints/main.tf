resource "aws_vpc_endpoint" "service_vpc_endpoint" {
  for_each = toset(var.service_names)

  service_name        = "com.amazonaws.${var.aws_region}.${each.value}"
  vpc_id              = var.vpc_id
  vpc_endpoint_type   = var.vpc_endpoint_type
  tags                = var.tags
  security_group_ids  = var.security_group_ids
  private_dns_enabled = var.private_dns_enabled
  subnet_ids          = var.subnet_ids
  route_table_ids     = var.route_table_ids
}
