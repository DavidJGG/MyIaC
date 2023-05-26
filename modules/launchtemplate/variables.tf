
variable "image_id" {
    description = "Tag name of the resources"
    default = "ami-0889a44b331db0194"
}  

variable "instance_type" {
    description = "Tag name of the resources"
    default = "t2.micro"
}  
variable "associate_public_ip_address" {
    description = "Tag name of the resources"
    type=bool
    default = true
}  
variable "delete_on_termination" {
    description = "Tag name of the resources"
    type=bool
    default = true
}  
variable "security_groups" {
    description = "Tag name of the resources"
    type = list(any)
}  

variable "efs_id" {
  description = "id of the efs"
  type = string
  default = ""
}

variable "tag_name" {
    description = "Tag name of the resources"
}

variable "user_data" {
  description = "Script to execute in the first boot of the ec2"
  type = string
  default = ""
}

variable "disk_size" {
    description = "Tag name of the resources"
    default = 8
}

variable "key_pair_name" {
    description = "Key pair name"
    default = ""
}