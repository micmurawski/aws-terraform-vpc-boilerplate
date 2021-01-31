output "service_vpc_endpoint_ids" {
  value = zipmap(keys(aws_vpc_endpoint.service_vpc_endpoint), values(aws_vpc_endpoint.service_vpc_endpoint).*.id)
}
