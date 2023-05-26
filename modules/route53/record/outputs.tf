output "dns" {
  value = aws_route53_record.resource_record.fqdn
}