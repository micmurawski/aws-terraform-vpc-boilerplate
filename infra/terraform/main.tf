module "storage" {
  source = "./modules/persistence"
  prefix = local.resource_prefix
  tags   = local.tags
}


module "event_bus" {
  source          = "./modules/event_bus"
  resource_prefix = local.prefix
  tags            = local.tags
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = format("%s-fm-vpc", local.prefix)
  cidr = var.cidr
  tags = local.tags

  azs             = var.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_dynamodb_endpoint                    = true
  enable_s3_endpoint                          = true
  cloudformation_endpoint_private_dns_enabled = true
  sns_endpoint_private_dns_enabled            = true
  enable_dns_hostnames                        = true
  enable_dns_support                          = true

  private_subnet_tags = {
    Tier = "private"
  }

  public_subnet_tags = {
    Tier = "public"
  }

  enable_nat_gateway     = true
  single_nat_gateway     = local.env_config[terraform.workspace].single_nat_gateway
  one_nat_gateway_per_az = local.env_config[terraform.workspace].one_nat_gateway_per_az
}

module "interface_vpc_endpoints" {
  source     = "./modules/vpc_endpoints"
  tags       = local.tags
  aws_region = var.aws_region
  security_group_ids = [
    module.vpc.default_security_group_id
  ]
  vpc_id              = module.vpc.vpc_id
  service_names       = var.interface_vpc_endpoints
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = module.vpc.private_subnets
}

module "dns" {
  source = "./modules/dns_zones"

  private_domain_name = var.base_domain_name
  public_domain_name  = var.base_domain_name
  tags                = local.tags
  private_zone_vpcs = [
    {
      vpc_id     = module.vpc.vpc_id,
      vpc_region = var.aws_region
    }
  ]
}

module "ssm_params" {
  source = "./modules/ssm_params"

  params = {
    format("/dataops/fm/%s_domain_name", terraform.workspace) = {
      type  = "String",
      value = var.base_domain_name
    },
    format("/dataops/fm/%s_domain_cert", terraform.workspace) = {
      type  = "String",
      value = module.dns.domain_cert_arn
    },
    "/dataops/fm/vpc_id" = {
      type  = "String",
      value = module.vpc.vpc_id
    },
    "/dataops/fm/event_bus_sns_topic" = {
      type  = "String",
      value = module.event_bus.name
    }
  }

  tags = local.tags
}
