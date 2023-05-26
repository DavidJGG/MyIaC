locals {
  tags = {
    Owner = "David"
    ORG   = "nClouds"
    Type  = "ELB component"
  }
}

resource "aws_elb" "elb" {
  name            = "elb-${var.tag_name}"
  subnets         = var.subnets
  security_groups = var.security_groups
  # internal           = false
  # load_balancer_type = "application"

  listener {
    instance_port      = var.instance_port
    instance_protocol  = var.instance_protocol
    lb_port            = var.lb_port
    lb_protocol        = var.lb_protocol
    ssl_certificate_id = var.certificate_id
  }

  health_check {
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.health_check_timeout
    target              = var.health_check_target
    interval            = var.health_check_interval
  }

  cross_zone_load_balancing   = var.cross_zone_load_balancing
  idle_timeout                = var.idle_timeout
  connection_draining         = var.connection_draining
  connection_draining_timeout = var.connection_draining_timeout

  tags = merge(local.tags, { Name = "elb-${var.tag_name}" })
}


# resource "aws_lb_listener" "lb_listener" {
#   load_balancer_arn = aws_lb.lb.arn
#   port              = "80"
#   protocol          = "HTTP"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.group.arn
#   }
# }

# resource "aws_lb_target_group" "group" {
#   name     = "tg-instance-${var.tag_name}"
#   target_type = "instance"
#   port     = var.instance_port
#   protocol = var.instance_protocol
#   vpc_id   = var.vpc_id
# }


