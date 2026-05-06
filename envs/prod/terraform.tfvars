project     = "lzsim"
env         = "prod"
aws_region  = "us-east-1"
region_code = "ue1"

vpc_cidr = "10.40.0.0/16"

public_subnet_cidrs = [
  "10.40.1.0/24",
  "10.40.2.0/24"
]

private_subnet_cidrs = [
  "10.40.11.0/24",
  "10.40.12.0/24"
]

enable_nat_gateway = false

common_tags = {
  Project     = "terraform-landing-zone-sim"
  Environment = "prod"
  ManagedBy   = "Terraform"
  Owner       = "Arkadiy"
}