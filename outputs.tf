output "efs_file_system_id" {
  value = aws_efs_file_system.efs.id
}

output "mount_target_1_id" {
  value = aws_efs_mount_target.mount_target_1.id
}

output "mount_target_2_id" {
  value = aws_efs_mount_target.mount_target_2.id
}

