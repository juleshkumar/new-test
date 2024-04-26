variable "vpc_id" {
  description = "The ID of the VPC where you want to create the EFS"
  type        = string
}

variable "efs_name" {
  description = "Name for the Elastic File System"
  type        = string
}

variable "sub1_id" {
  type        = string
  description = "List of Subnet 1 IDs in which to create the mount targets"
}

variable "sub2_id" {
  type        = string
  description = "List of Subnet 2 IDs in which to create the mount targets"
}

variable "region" {
  type        = string
  description = "aws region "
}
