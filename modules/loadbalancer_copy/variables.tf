# variable "vpc_id" {
#   description = "Id of the vpc"
# }

variable "certificate_id" {
  description = "certificate_id"
}

variable "subnets" {
  description = "Subnets to associate with elb"
  type        = list(any)
}

variable "security_groups" {
  description = "Security groups to associate with elb"
  type        = list(any)
}

variable "instance_port" {
  description = "Instance port"
  default = 80
}
variable "instance_protocol" {
  description = "Instance protocol"
  default = "http"
}
variable "lb_port" {
  description = "Load balancer port"
  default = 80
}
variable "lb_protocol" {
  description = "Load balancer protocol"
  default = "http"
}

# variable "instance_port2" {
#   description = "Instance port"
#   default = 80
# }
# variable "instance_protocol2" {
#   description = "Instance protocol"
#   default = "http"
# }
# variable "lb_port2" {
#   description = "Load balancer port"
#   default = 443
# }
# variable "lb_protocol2" {
#   description = "Load balancer protocol"
#   default = "https"
# }

variable "healthy_threshold" {
  description = "Healthy threshold"
  default = 2
}
variable "unhealthy_threshold" {
  description = "Unhealthy threshold"
  default = 2
}
variable "health_check_timeout" {
  description = "Health check timeout"
  default = 3
}
variable "health_check_target" {
  description = "Health check target"
  default = "HTTP:80/"
}

variable "health_check_interval" {
  description = "Health check interval"
  default = 30
}
variable "cross_zone_load_balancing" {
  description = "Cross zone load balancing"
  default = true
}
variable "idle_timeout" {
  description = "Idle tiemout"
  default = 400
}
variable "connection_draining" {
  description = "Connection daining"
  default = true
}
variable "connection_draining_timeout" {
  description = "Connection draining timeout"
  default = 400
}



variable "tag_name" {
  description = "Tag name of the resources"
}

# variable "elb_listeners" {
#   type = list(object({
#     instance_port = number
#     instance_protocol = string
#     lb_port = number
#     lb_protocol = string
#   }))
# }