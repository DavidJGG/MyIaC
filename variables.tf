variable "profile_names" {
  description = "Workspace profile"
  default = {
    "virginia" = "nclouds-account"
    "proy" = "nclouds-account"
  }
}

variable "aws_region" {
  description = "Workspace profile"
  default = {
    "virginia" = "us-east-1"
    "proy" = "us-east-2"
  }
}

variable "tag_name" {
  description = "Tag name to identify the resources"
  type        = string
}


variable "vpc_config" {
  description = "Set of variables for vpc"
}


variable "efs_config" {
  description = "Set of variables for efs"
}

variable "web_server_launchTemplate" {
  description = "Set of variables for launch template for the web servers"
}

variable "route53_certificate" {
  description = "Set of variables for ACM certificate"
}

variable "aplication_load_balancer" {
  description = "Set of variables for the Aplication Load Balancer"
}


variable "web_servers_autoscaling_group" {
  description = "Set of variables for the Autoscaling Group"
}

variable "route53_resource" {
  description = "Set of variables for a route record"
}


###################################################
# START EC2 DEPLOY INSTANCE VARIABLES
###################################################

variable "deployer_launchTemplate" {
  description = "Set of variables for launch template for the deployer ec2"
}

variable "deployer_autoscaling_group" {
  description = "Set of variables for the auto scaling group that will launch the deployer_launchTemplate"
}

variable "bastion_launchTemplate" {
  description = "Set of variables for launch template for the bastion host ec2"
}

variable "bastion_autoscaling_group" {
  description = "Set of variables for the auto scaling group that will launch the bastion_launchTemplate"
}
