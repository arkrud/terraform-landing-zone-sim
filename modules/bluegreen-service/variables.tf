variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "region_code" {
  type = string
}

variable "active_slot" {
  type = string

  validation {
    condition     = contains(["blue", "green"], var.active_slot)
    error_message = "active_slot must be blue or green."
  }
}

variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "common_tags" {
  type = map(string)
}
