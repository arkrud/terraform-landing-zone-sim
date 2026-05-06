project     = "lzsim"
env         = "dev"
aws_region  = "us-east-1"
region_code = "ue1"

vpc_cidr = "10.10.0.0/16"

public_subnet_cidrs = [
  "10.10.1.0/24",
  "10.10.2.0/24"
]

private_subnet_cidrs = [
  "10.10.11.0/24",
  "10.10.12.0/24"
]

enable_nat_gateway = true

common_tags = {
  Project     = "terraform-landing-zone-sim"
  Environment = "dev"
  ManagedBy   = "Terraform"
  Owner       = "Arkadiy"
}

terraform_execution_role_arn = "arn:aws:iam::737213638848:role/lzsim-dev-tf-exec-role"

enable_service_blue  = true
enable_service_green = true

service_instance_type = "t3.micro"

admin_cidr_blocks = []

enable_bluegreen_service = true
active_slot              = "green"
