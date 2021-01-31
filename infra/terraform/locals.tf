locals {
  prefix          = terraform.workspace
  resource_prefix = format("%s-%s-%s-core", var.project_name, var.environment, var.stage)

  env_config = {
    default = {
      num_public_subnets     = 1
      num_private_subnets    = 1
      single_nat_gateway     = true
      one_nat_gateway_per_az = false
    },
    proto = {
      num_public_subnets     = 1
      num_private_subnets    = 1
      single_nat_gateway     = true
      one_nat_gateway_per_az = false
    },
    dev = {
      num_public_subnets     = 1
      num_private_subnets    = 1
      single_nat_gateway     = true
      one_nat_gateway_per_az = false
    },
    qa = {
      num_public_subnets     = 1
      num_private_subnets    = 1
      single_nat_gateway     = true
      one_nat_gateway_per_az = false
    },
    preprod = {
      num_public_subnets     = 2
      num_private_subnets    = 2
      single_nat_gateway     = false
      one_nat_gateway_per_az = true
    },
    customer = {
      num_public_subnets     = 2
      num_private_subnets    = 2
      single_nat_gateway     = false
      one_nat_gateway_per_az = true
    },
    canary = {
      num_public_subnets     = 1
      num_private_subnets    = 1
      single_nat_gateway     = true
      one_nat_gateway_per_az = false
    }
  }
  public_subnets = [
    for x in range(local.env_config[terraform.workspace].num_public_subnets) : cidrsubnet(cidrsubnet(var.cidr, 2, 0), 6, x)
  ]
  private_subnets = [
    for x in range(local.env_config[terraform.workspace].num_private_subnets) : cidrsubnet(cidrsubnet(var.cidr, 2, 1), 6, x)
  ]

  tags = {
    "Project"     = var.project_name
    "Environment" = var.environment
    "Stage"       = var.stage
  }
}

