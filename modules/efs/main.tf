locals {
  tags = {
    Owner       = "David"
    ORG         = "nClouds"
    Description = "Element necesary to build a EFS"
  }
}


resource "aws_efs_file_system" "efs" {

  creation_token   = var.creation_token
  encrypted        = var.encrypted
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode

  tags = merge(local.tags, { Name = "efs-${var.tag_name}" })
}

resource "aws_efs_mount_target" "mount_target" {
  count          = var.number_of_private_subnets_available
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = element(var.list_of_private_subnets_id[*], count.index)
  security_groups = [ var.efs_sg_id ]

  depends_on = [ aws_efs_file_system.efs ]
}



