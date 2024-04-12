# Define variables
variable "instance_sg_name" {
  description = "The name of the sg "
}

variable "ami" {
  description = "ami id "
}

variable "instance_type" {
  description = "instance type"
}

variable "key_pair" {
  description = "keypair for server "
}

variable "subnet_id" {
  description = "subnet id from above stage"
}

variable "vpc_id" {
  description = "vpc id from above stage "
}
