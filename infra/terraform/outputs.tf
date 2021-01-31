output "public_subnets_ips" {
  value = local.public_subnets
}

output "private_subnets_ips" {
  value = local.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "interface_vpc_endpoints_ids" {
  value = module.interface_vpc_endpoints.service_vpc_endpoint_ids
}

output "domian_cert_arn" {
  value = module.dns.domain_cert_arn
}

output "event_bus_arn" {
  value = module.event_bus.arn
}
