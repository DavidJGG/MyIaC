output "group_arn" {
  value = aws_lb_target_group.group.arn
}

output "alb_dns" {
  value = aws_lb.lb.dns_name
}