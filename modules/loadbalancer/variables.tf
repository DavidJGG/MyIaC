
variable "vpc_id" {
  description = "vpc_id"
}

variable "enable_redirect" {
  description="enable_redirection"
  default=true
}

variable "redirect_from_port" {
  description = "redirect_from_port"
  default="80"
}

variable "redirect_from_protocol" {
  description = "redirect_from_protocol"
  default="HTTP"
}

variable "redirect_to_port" {
  description = "redirect_to_port"
  default="443"
}

variable "redirect_to_protocol" {
  description = "redirect_to_protocol"
  default="HTTPS"
}

variable "redirect_status_code" {
  description = "redirect_status_code"
  default="HTTP_301"
}


variable "internal" {
  description = "Is internal?"
  default = false
}


variable "load_balancer_type" {
  description = "Load balancer type"
  default = "application"
}


variable "security_groups_id" {
  description = "Security group id"
  type = list(string)
}

variable "subnets_id" {
  description = "Subnets id"
  type = list(string)
}

variable "port" {
  description = "SSL policy"
  default = "443"
}

variable "protocol" {
  description = "SSL policy"
  default = "HTTPS"
}

variable "ssl_policy" {
  description = "SSL policy"
  default = "ELBSecurityPolicy-2016-08"
}

variable "certificate_arn" {
  description = "Certificate arn"
}

variable "instances_group_port" {
  description = "instances_group_port"
  default = 80
}

variable "instances_group_protocol" {
  description = "instances_group_protocol"
  default = "HTTP"
}

variable "tag_name" {
  description = "Tag name of the resources"
}