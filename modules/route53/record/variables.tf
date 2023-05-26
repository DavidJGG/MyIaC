variable "resource_dns" {
  description = "resource_dns"
}

variable "hosted_zone_name" {
  description = "Hosted zone name"
}

variable "resource_record_name" {
  description = "Resource record name"
}

variable "resource_record_type" {
  description = "Resource record type"
}

variable "resource_record_ttl" {
  description = "Resource record ttl"
  default = 300
}


variable "tag_name" {
    description = "Tag name of the resources"
}