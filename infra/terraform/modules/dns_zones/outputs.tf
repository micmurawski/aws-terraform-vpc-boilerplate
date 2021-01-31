output "public_zone_ids" {
  description = "The ID of the created public zone."
  value       = data.aws_route53_zone.public.id
}

output "public_zone_name_servers" {
  description = "The nameservers of the created public zone."
  value       = data.aws_route53_zone.public.name_servers
}

output "private_zone_ids" {
  description = "The ID of the created private zone."
  value       = aws_route53_zone.private.*.id
}

output "private_zone_name_servers" {
  description = "The nameservers of the created private zone."
  value       = aws_route53_zone.private.*.name_servers
}

output "domain_cert_arn" {
  value = aws_acm_certificate.domain_cert.arn
}

output "base_domain_cert_arn" {
  value = aws_acm_certificate.base_domain_cert.arn
}
