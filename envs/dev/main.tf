terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {}
}


# bootstrap provider (no assume role)
provider "aws" {
  alias  = "bootstrap"
  region = var.aws_region

  default_tags {
    tags = var.common_tags
  }
}

# target provider (assume role)
provider "aws" {
  region = var.aws_region
  alias  = "target"
  //assume_role {
  //   role_arn = var.terraform_execution_role_arn
  //}

  default_tags {
    tags = var.common_tags
  }
}




module "network" {
  source = "../../modules/network"

  providers = {
    aws = aws.target
  }

  project              = var.project
  env                  = var.env
  region_code          = var.region_code
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  enable_nat_gateway   = var.enable_nat_gateway
  common_tags          = var.common_tags
}

module "account_baseline" {
  source = "../../modules/account-baseline"

  providers = {
    aws = aws.bootstrap
  }

  project     = var.project
  env         = var.env
  common_tags = var.common_tags
}
/*
module "service_blue" {
  count  = var.enable_service_blue ? 1 : 0
  source = "../../modules/service"

  project            = var.project
  env                = var.env
  region_code        = var.region_code
  slot               = "blue"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  instance_type      = var.service_instance_type
  admin_cidr_blocks  = var.admin_cidr_blocks
  common_tags        = var.common_tags
}
*/
/*
module "service_green" {
  count  = var.enable_service_green ? 1 : 0
  source = "../../modules/service"

  project            = var.project
  env                = var.env
  region_code        = var.region_code
  slot               = "green"
  vpc_id             = module.network.vpc_id
  public_subnet_ids  = module.network.public_subnet_ids
  private_subnet_ids = module.network.private_subnet_ids
  instance_type      = var.service_instance_type
  admin_cidr_blocks  = var.admin_cidr_blocks
  common_tags        = var.common_tags
}

output "blue_alb_dns_name" {
  value = var.enable_service_blue ? module.service_blue[0].alb_dns_name : null
}

output "green_alb_dns_name" {
  value = var.enable_service_green ? module.service_green[0].alb_dns_name : null
}

*/
/*
module "bluegreen_service" {
  count  = var.enable_bluegreen_service ? 1 : 0
  source = "../../modules/bluegreen-service"

  project           = var.project
  env               = var.env
  region_code       = var.region_code
  active_slot       = var.active_slot
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  instance_type     = var.service_instance_type
  common_tags       = var.common_tags
} 

output "bluegreen_alb_dns_name" {
  value = var.enable_bluegreen_service ? module.bluegreen_service[0].alb_dns_name : null
}

output "bluegreen_active_slot" {
  value = var.enable_bluegreen_service ? module.bluegreen_service[0].active_slot : null
}
*/

output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}



