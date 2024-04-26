variable "vpc_id" {
  description = "The ID of the VPC where you want to create the EFS"
}

variable "efs_name" {
  description = "Name for the Elastic File System"
  default     = "my-efs"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of Subnet IDs in which to create the mount targets"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of Security Group IDs to associate with the EFS"
}
