resource "aws_security_group" "efs_sg" {
  name        = "efs-security-group"
  description = "Security group for EFS"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["10.87.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_file_system" "efs" {
  creation_token  = var.efs_name
  performance_mode = "generalPurpose"
  tags = {
    Name = var.efs_name
  }
}

resource "aws_efs_mount_target" "mount_targets" {
  count           = length(var.subnet_ids)
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = ["var.sub1_id", "var.sub2_id"]
  security_groups = [aws_security_group.efs_sg.id]
}
