output "vpc_id" {
  value = aws_vpc.vpc_cfg.id
}

output "public_subnets_id" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnets_id" {
  value = aws_subnet.private_subnets[*].id
}

output "sg_ec2_id" {
  value = aws_security_group.sg_ec2.id
}

output "sg_efs_id" {
  value = aws_security_group.sg_efs.id
}

output "sg_elb_id" {
  value = aws_security_group.sg_elb.id
}

output "sg_ec2_allow_ssh_id" {
  value = aws_security_group.sg_ec2_allow_ssh.id
}