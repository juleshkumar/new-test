output "vpc_id" {
  value       = aws_vpc.test.id
  description = "VPC ID"
}

output "public_subnet_a_ids" {
  value       = aws_subnet.public-sub-1a.id
  description = "public subnet 1a id"
}

output "public_subnet_b_ids" {
  value       = aws_subnet.public-sub-1b.id
  description = "public subnet 1b id"
}

output "private_subnet_a_ids" {
  value       = aws_subnet.private-sub-1a.id
  description = "private subnet 1a id"
}

output "private_subnet_b_ids" {
  value       = aws_subnet.private-sub-1b.id
  description = "private subnet 1b id"
}

output "cidr_block" {
  value       = var.cidr_block
  description = "The CIDR block associated with the VPC"
}
