locals {
  tags = {
    Owner = "David"
    ORG   = "nClouds"
    Type  = "Launch template component"
  }
}


#### CREATING THE TEMPLATE

resource "aws_launch_template" "launchTemplate" {
  name                                 = "${var.tag_name}-LaunchTemplate"
  image_id                             = var.image_id
  instance_initiated_shutdown_behavior = "terminate"
  instance_type                        = var.instance_type
  
  update_default_version = true

  iam_instance_profile {
    arn  = aws_iam_instance_profile.iamEfsProfile.arn
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }


  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = var.delete_on_termination
    security_groups             = var.security_groups
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = var.disk_size
      delete_on_termination = true
      encrypted = true
    }
  }

  private_dns_name_options {
    enable_resource_name_dns_a_record = true
  }

  key_name = length(var.key_pair_name)>0 ? var.key_pair_name : aws_key_pair.myKey[0].key_name

  user_data = var.user_data
  

  tags = merge(local.tags, { Name = "LaunchTemplate-${var.tag_name}" })

  depends_on = [aws_iam_instance_profile.iamEfsProfile]
}


resource "aws_iam_instance_profile" "iamEfsProfile" {
  name = "efsProfile-${var.tag_name}"
  role = aws_iam_role.roleEfs.name

  depends_on = [aws_iam_role.roleEfs]
}

resource "aws_key_pair" "myKey" {
  count = length(var.key_pair_name)>0 ? 0 : 1
  key_name   = "davidKey${var.tag_name}"
  public_key = file("${path.module}/davidKeyTerraform.pub")
}

###### CREATING POLITICS AND ROLES TO ALLOW THE COMUNICATION WITH EFS

resource "aws_iam_role" "roleEfs" {

  name = "roleEfs-${var.tag_name}"

  assume_role_policy  = data.aws_iam_policy_document.asumeRole.json
  managed_policy_arns = [aws_iam_policy.efsClientPolicy.arn]

  tags = merge(local.tags, { Name = "roleEfs-${var.tag_name}" })

  depends_on = [aws_iam_policy.efsClientPolicy]

}

data "aws_iam_policy_document" "asumeRole" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "efsClientPolicy" {
  name = "efsClientPolicy-${var.tag_name}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "elasticfilesystem:ClientMount",
        "elasticfilesystem:ClientWrite",
        "elasticfilesystem:DescribeMountTargets"
      ]
      Resource = "*"
    }]
    }
  )

  tags = merge(local.tags, { Name = "efsClientPolicy-${var.tag_name}" })
}



