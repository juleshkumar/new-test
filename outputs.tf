output "instance_public_ip" {
  value = aws_instance.jumpbox.public_ip
}

output "instance_private_ip" {
  value = aws_instance.jumpbox.private_ip
}

output "security_group_id" {
  value = aws_security_group.jumpbox_sg.id
}
