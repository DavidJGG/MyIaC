variable "validation_method" {
  description = "validation_method"
  default = "DNS"
}


variable "fdqn" {
  description = "Complete dns to apply a certificate"
}

variable "hosted_zone_name" {
  description = "Hosted zone name"
}

variable "validator_record_ttl" {
  description = "Validator of ssl/tls record ttl"
  default = 300
}

variable "key_algorithm" {
  description = "Key algorithm"
  default = "RSA_2048"
}

variable "tag_name" {
    description = "Tag name of the resources"
}