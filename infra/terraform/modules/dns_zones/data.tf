data "aws_route53_zone" "public" {
  name         = var.public_domain_name
  private_zone = false
}


