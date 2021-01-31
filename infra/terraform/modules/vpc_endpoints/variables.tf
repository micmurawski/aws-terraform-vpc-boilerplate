variable "vpc_id" {}
variable "aws_region" {}
variable "vpc_endpoint_type" {}
variable "service_names" {
  type = list(string)
}
variable "security_group_ids" {
  type    = list(string)
  default = []
}
variable "tags" {
  type = map
}
variable "route_table_ids" {
  type    = list(string)
  default = []
}

variable "subnet_ids" {
  type    = list(string)
  default = []
}

variable "private_dns_enabled" {
  type    = bool
  default = false
}