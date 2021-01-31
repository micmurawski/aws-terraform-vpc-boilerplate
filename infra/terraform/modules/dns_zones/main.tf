resource "aws_route53_zone" "private" {
  count = var.private_domain_name == null ? 0 : 1

  name = format("%s.", var.private_domain_name)

  dynamic "vpc" {
    for_each = var.private_zone_vpcs
    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = vpc.value.vpc_region
    }
  }
}

resource "aws_acm_certificate" "domain_cert" {
  domain_name       = format("*.%s", var.public_domain_name)
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "base_domain_cert" {
  domain_name       = var.public_domain_name
  validation_method = "DNS"

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "domain_cert_record" {
  for_each = {
    for dvo in aws_acm_certificate.domain_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
  zone_id = data.aws_route53_zone.public.zone_id
}
