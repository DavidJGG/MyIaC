variable "subnets_id" {
    description = "Subnets id where resources will be deployed"
    type = list(string)
}

variable "desired_capacity" {
    description = "Desired capacity"
    type = number
    default = 1
}

variable "min_size" {
    description = "Min size"
    type = number
    default = 1
}

variable "max_size" {
    description = "Max size"
    type = number
    default = 1
}

variable "launch_template_id" {
    description = "Launch template id"
    type = string
}

variable "launch_template_version" {
    description = "Launch template version"
    default = "$Default"
    type = string
}

variable "elb_id" {
    description = "Load balancer id"
    type = list(string)
    default = []
}

variable "target_group_arns" {
  description = "target_group_arns"
  type = list(string)
  default = []
}

variable "tag_name" {
    description = "Tag name of the resources"
}