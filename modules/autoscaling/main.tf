locals {
  tags = {
    Owner = "David"
    ORG   = "nClouds"
    Type  = "ASG component"
  }
}

resource "aws_autoscaling_group" "asg" {
  vpc_zone_identifier = var.subnets_id
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  load_balancers      = var.elb_id
  target_group_arns   = var.target_group_arns
  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }

  name = "asg-${var.tag_name}"
}
