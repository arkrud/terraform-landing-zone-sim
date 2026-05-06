variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "region_code" {
  type = string
}

variable "slot" {
  type = string

  validation {
    condition     = contains(["blue", "green"], var.slot)
    error_message = "slot must be blue or green."
  }
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "admin_cidr_blocks" {
  type    = list(string)
  default = []
}

variable "common_tags" {
  type = map(string)
}
