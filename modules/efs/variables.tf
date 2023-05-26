

variable "encrypted" {
  description = "Throughput mode for the file system."
  type        = bool
  default     = false
}

variable "creation_token" {
  description = "Throughput mode for the file system."
  default     = "efs-nClouds"
}

variable "throughput_mode" {
  description = "Throughput mode for the file system."
  default     = "elastic"
}

variable "performance_mode" {
  description = "The file system performance mode"
  default     = "generalPurpose"
}


variable "number_of_private_subnets_available" {
  description = "number of private subnets available to put efs mount targets"
  type        = number
}

variable "vpc_id" {
  description = "Id of the vpc in use"
  nullable    = false
  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "The vpc id must start wit vpc-"
  }
}

variable "source_security_group_id" {
  description = "Security group that will be able to connect with the efs"
  nullable    = false
  validation {
    condition     = can(regex("^sg-", var.source_security_group_id))
    error_message = "The security group id must start wit sg-"
  }
}

variable "list_of_private_subnets_id" {
  description = "number of private subnets available to put efs mount targets"
  type        = list(any)
}

variable "efs_sg_id" {
  description = "Security group for the EFS"
  nullable    = false
  validation {
    condition     = can(regex("^sg-", var.efs_sg_id))
    error_message = "The security group id must start wit sg-"
  }
}

variable "tag_name" {
  description = "Tag name of the resources"
}
