project     = "lzsim"
env         = "qa"
aws_region  = "us-east-1"
region_code = "ue1"

vpc_cidr = "10.20.0.0/16"

public_subnet_cidrs = [
  "10.20.1.0/24",
  "10.20.2.0/24"
]

private_subnet_cidrs = [
  "10.20.11.0/24",
  "10.20.12.0/24"
]

enable_nat_gateway = false

common_tags = {
  Project     = "terraform-landing-zone-sim"
  Environment = "qa"
  ManagedBy   = "Terraform"
  Owner       = "Arkadiy"
}

terraform_execution_role_arn = "arn:aws:iam::737213638848:role/lzsim-qa-tf-exec-role"