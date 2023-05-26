
locals {
  tags = {
    Owner = "David"
    ORG   = "nClouds"
    Type  = "R53 ACM component"
  }
}

data "aws_route53_zone" "z" {
  name         = var.hosted_zone_name
  private_zone = false
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.fdqn
  validation_method = var.validation_method
  key_algorithm = var.key_algorithm
  tags = merge(local.tags, { Name = "cert-${var.tag_name}" })
}

resource "aws_route53_record" "validator_record" {
for_each = {
    for obj in aws_acm_certificate.cert.domain_validation_options : obj.domain_name => {
      resource_record_name   = obj.resource_record_name
      resource_record_value = obj.resource_record_value
      resource_record_type   = obj.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.z.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = var.validator_record_ttl
  records = [each.value.resource_record_value]
  
  depends_on = [ aws_acm_certificate.cert ]
}