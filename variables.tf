variable "name" {
  type        = string
  description = "Name of the VPC"
}

variable "project" {
  type        = string
  description = "Name of project this VPC is meant to house"
}

variable "environment" {
  type        = string
  description = "Name of environment this VPC is targeting"
}

variable "region" {
  type        = string
  description = "Region of the VPC"
}

variable "cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "availability_zone_one" {
  type        = string
  description = "List of availability zone 1"
}

variable "availability_zone_two" {
  type        = string
  description = "List of availability zone 2"
}

variable "public_subnet_a_cidr_blocks" {
  type        = string
  description = "public subnet 1a CIDR blocks"
}

variable "public_subnet_b_cidr_blocks" {
  type        = string
  description = "public subnet 1b CIDR blocks"
}

variable "private_subnet_a_cidr_blocks" {
  type        = string
  description = "private subnet 1a CIDR blocks"
}

variable "private_subnet_b_cidr_blocks" {
  type        = string
  description = "private subnet 1b CIDR blocks"
}
