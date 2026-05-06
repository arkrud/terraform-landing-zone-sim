variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "region_code" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_subnet_cidrs" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "common_tags" {
  type = map(string)
}

variable "terraform_execution_role_arn" {
  type = string
}

variable "enable_service_blue" {
  type    = bool
  default = false
}

variable "enable_service_green" {
  type    = bool
  default = false
}

variable "service_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "admin_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "enable_bluegreen_service" {
  type    = bool
  default = false
}

variable "active_slot" {
  type    = string
  default = "blue"
}
