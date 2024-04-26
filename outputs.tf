output "efs_id" {
  value = aws_efs_file_system.example.id
}

output "mount_target_ips" {
  value = aws_efs_mount_target.example[*].ip_address
}
