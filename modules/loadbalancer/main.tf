locals {
  tags = {
    Owner = "David"
    ORG   = "nClouds"
    Type  = "LB component"
  }
}


resource "aws_lb" "lb" {
  name               = "lb-${var.tag_name}"
  internal           = var.internal
  load_balancer_type = var.load_balancer_type
  security_groups    = var.security_groups_id
  subnets            = var.subnets_id


  tags = merge(local.tags, { Name = "lb-${var.tag_name}" })
}

resource "aws_lb_listener" "lsn_secured" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.port
  protocol          = var.protocol
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.group.arn
  }

  depends_on = [ aws_lb.lb, aws_lb_target_group.group ]
}

resource "aws_lb_listener" "lsn_redirect" {
  count             = var.enable_redirect ? 1 : 0
  load_balancer_arn = aws_lb.lb.arn
  port              = var.redirect_from_port
  protocol          = var.redirect_from_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = var.redirect_to_port
      protocol    = var.redirect_to_protocol
      status_code = var.redirect_status_code
    }
  }

  depends_on = [ aws_lb.lb ]
}

resource "aws_lb_target_group" "group" {
  name     = "tg-${var.tag_name}"
  port     = var.instances_group_port
  protocol = var.instances_group_protocol
  vpc_id   = var.vpc_id
  tags     = merge(local.tags, { Name = "tg-${var.tag_name}" })
}
