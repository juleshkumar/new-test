output "efs_file_system_id" {
  value = aws_efs_file_system.efs.id
}

output "efs_mount_target_1.id" {
  value = aws_efs_mount_target.mount_target_1.id
}

output "efs_mount_target_2.id" {
  value = aws_efs_mount_target.mount_target_2.id
}

