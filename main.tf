module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_config.vpc_cidr
  tag_name = var.tag_name
}


module "efs" {
  source                              = "./modules/efs"
  encrypted                           = var.efs_config.encrypted
  creation_token                      = var.efs_config.creation_token
  throughput_mode                     = var.efs_config.throughput_mode
  performance_mode                    = var.efs_config.performance_mode
  number_of_private_subnets_available = length(module.vpc.private_subnets_id)
  vpc_id                              = module.vpc.vpc_id
  source_security_group_id            = module.vpc.sg_ec2_id
  efs_sg_id                           = module.vpc.sg_efs_id
  list_of_private_subnets_id          = module.vpc.private_subnets_id
  tag_name                            = var.tag_name
}

module "launchTemplate" {
  source                              = "./modules/launchtemplate"
  image_id                    = var.web_server_launchTemplate.image_id #"ami-0889a44b331db0194"
  instance_type               = var.web_server_launchTemplate.instance_type
  associate_public_ip_address = var.web_server_launchTemplate.associate_public_ip_address
  delete_on_termination       = var.web_server_launchTemplate.delete_on_termination
  security_groups             = tolist([module.vpc.sg_ec2_id])
  tag_name                    = var.tag_name
  efs_id                      = module.efs.efs_id
  disk_size                   = var.web_server_launchTemplate.disk_size
  user_data                   = base64encode(templatefile("${path.module}${var.web_server_launchTemplate.path_user_data}", { efs_id = module.efs.efs_id }))
}

module "route53_certificate" {
  source             = "./modules/route53/acm"
  hosted_zone_name   = var.route53_certificate.hosted_zone_name
  fdqn               = var.route53_certificate.fdqn
  tag_name           = var.tag_name
}

module "lb" {
  source             = "./modules/loadbalancer"
  subnets_id         = module.vpc.public_subnets_id
  security_groups_id = [module.vpc.sg_elb_id]
  vpc_id             = module.vpc.vpc_id
  port               = var.aplication_load_balancer.port
  protocol           = var.aplication_load_balancer.protocol
  certificate_arn    = module.route53_certificate.ssl_arn
  tag_name           = var.tag_name
  depends_on         = [module.route53_certificate]
}


module "asg" {
  source             = "./modules/autoscaling"
  subnets_id         = module.vpc.private_subnets_id
  desired_capacity   = var.web_servers_autoscaling_group.desired_capacity
  min_size           = var.web_servers_autoscaling_group.min_size
  max_size           = var.web_servers_autoscaling_group.max_size
  launch_template_id = module.launchTemplate.launch_template_id
  target_group_arns  = [module.lb.group_arn]
  tag_name           = var.tag_name
}

module "route53_resource" {
  source                 = "./modules/route53/record"
  hosted_zone_name       = var.route53_resource.hosted_zone_name
  resource_record_name   = var.route53_resource.resource_record_name
  resource_dns           = module.lb.alb_dns
  resource_record_type   = var.route53_resource.resource_record_type
  tag_name               = var.tag_name


  depends_on = [module.lb]
}


###################################################
# START EC2 DEPLOY INSTANCE CONFIGURATION
###################################################

module "deployer_launchTemplate" {
  source                      = "./modules/launchtemplate"
  image_id                    = var.deployer_launchTemplate.image_id # "ami-0889a44b331db0194"
  instance_type               = var.deployer_launchTemplate.instance_type
  associate_public_ip_address = var.deployer_launchTemplate.associate_public_ip_address
  delete_on_termination       = var.deployer_launchTemplate.delete_on_termination
  security_groups             = tolist([module.vpc.sg_ec2_id])
  disk_size                   = var.deployer_launchTemplate.disk_size
  user_data                   = base64encode(templatefile("${path.module}${var.deployer_launchTemplate.path_user_data}", { efs_id = module.efs.efs_id }))
  key_pair_name               = var.deployer_launchTemplate.key_pair_name
  tag_name                    = "deployer-${var.tag_name}"
}

module "deployer_asg" {
  source             = "./modules/autoscaling"
  subnets_id         = module.vpc.private_subnets_id
  desired_capacity   = var.deployer_autoscaling_group.desired_capacity
  min_size           = var.deployer_autoscaling_group.min_size
  max_size           = var.deployer_autoscaling_group.max_size
  launch_template_id = module.deployer_launchTemplate.launch_template_id
  tag_name           = "deployer-${var.tag_name}"
}

###################################################
# END EC2 DEPLOY INSTANCE CONFIGURATION
###################################################


###################################################
# START BASTION HOST CONFIGURATION
###################################################

module "bastion_launchTemplate" {
  source                      = "./modules/launchtemplate"
  image_id                    = var.bastion_launchTemplate.image_id # "ami-0889a44b331db0194"
  instance_type               = var.bastion_launchTemplate.instance_type
  associate_public_ip_address = var.bastion_launchTemplate.associate_public_ip_address
  delete_on_termination       = var.bastion_launchTemplate.delete_on_termination
  disk_size                   = var.bastion_launchTemplate.disk_size
  key_pair_name               = var.bastion_launchTemplate.key_pair_name
  security_groups             = tolist([module.vpc.sg_ec2_allow_ssh_id])
  user_data                   = base64encode(templatefile("${path.module}${var.bastion_launchTemplate.path_user_data}", { keyName = var.bastion_launchTemplate.key_pair_name }))
  tag_name                    = "bastion-${var.tag_name}"
}

module "bastion_asg" {
  source             = "./modules/autoscaling"
  subnets_id         = module.vpc.public_subnets_id
  desired_capacity   = var.bastion_autoscaling_group.desired_capacity
  min_size           = var.bastion_autoscaling_group.min_size
  max_size           = var.bastion_autoscaling_group.max_size
  launch_template_id = module.bastion_launchTemplate.launch_template_id
  tag_name           = "bastion-${var.tag_name}"
  
}

###################################################
# END BASTION HOST CONFIGURATION
###################################################
