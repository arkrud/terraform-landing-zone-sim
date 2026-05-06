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

provider "aws" {
  region = var.aws_region
  //assume_role {
  //  role_arn = var.terraform_execution_role_arn
  //}

  default_tags {
    tags = var.common_tags
  }
}

module "network" {
  source = "../../modules/network"

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


  project     = var.project
  env         = var.env
  common_tags = var.common_tags
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "public_subnet_ids" {
  value = module.network.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.network.private_subnet_ids
}
