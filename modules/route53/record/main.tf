
locals {
  tags = {
    Owner = "David"
    ORG   = "nClouds"
    Type  = "R53 Record component"
  }
}

data "aws_route53_zone" "z" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_route53_record" "resource_record" {
  zone_id = data.aws_route53_zone.z.zone_id
  name    = var.resource_record_name
  type    = var.resource_record_type
  ttl     = var.resource_record_ttl
  
  records = [var.resource_dns]
}