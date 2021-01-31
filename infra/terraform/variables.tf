variable "cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "172.30.0.0/16"
}

variable aws_region {
  default = "us-east-1"
}

variable "azs" {
  type    = list
  default = ["us-east-1a"]
}

variable environment {
  type = string
}

variable stage {
  type = string
}

variable project_name {
  type = string
}

variable "base_domain_name" {
  type = string
}

variable "interface_vpc_endpoints" {
  type    = list(string)
  default = ["sns", "states", "cloudformation", "sts", "execute-api", "ssm"]
}
