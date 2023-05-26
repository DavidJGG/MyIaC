locals {
  tags = {
    Owner = "David"
    ORG   = "nClouds"
    Type  = "VPC component"
  }
}

data "aws_availability_zones" "az" {
  state = "available"
}

# VPC CONFIG
resource "aws_vpc" "vpc_cfg" {
  cidr_block           = var.vpc_cidr
  tags                 = merge(local.tags, { Name = "vpc-${var.tag_name}" })
  enable_dns_hostnames = true
  enable_dns_support   = true
}

#########################################################################################
# PUBLIC SUBNETS CONFIGURATION
#########################################################################################

### PUBLIC SUBNETS
resource "aws_subnet" "public_subnets" {
  count                = length(data.aws_availability_zones.az.zone_ids)
  vpc_id               = aws_vpc.vpc_cfg.id
  cidr_block           = cidrsubnet(var.vpc_cidr, 8, count.index + 1)
  availability_zone_id = data.aws_availability_zones.az.zone_ids[count.index]

  tags = merge(local.tags, { Name = "pubSub-${count.index + 1}-${var.tag_name}" })
  depends_on = [
    aws_vpc.vpc_cfg
  ]
}


# INTERNET GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_cfg.id

  tags = merge(local.tags, { Name = "igw-${var.tag_name}" })

  depends_on = [aws_vpc.vpc_cfg]
}

# CREATE PUBLIC ROUTE TABLE
resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.vpc_cfg.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(local.tags, { Name = "PubRouteTable-${var.tag_name}" })

  depends_on = [
    aws_subnet.public_subnets,
    aws_internet_gateway.igw
  ]

}

# JOIN PUBLIC SUBNETS WITH PUBLIC ROUTE TABLE

resource "aws_route_table_association" "public_asoc" {
  count          = length(data.aws_availability_zones.az.zone_ids)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.rt_public.id

  depends_on = [
    aws_subnet.public_subnets,
    aws_route_table.rt_public
  ]
}

#########################################################################################
# PRIVATE SUBNETS CONFIGURATION
#########################################################################################

# PRIVATE SUBNETS
resource "aws_subnet" "private_subnets" {
  count                = length(data.aws_availability_zones.az.zone_ids)
  vpc_id               = aws_vpc.vpc_cfg.id
  cidr_block           = cidrsubnet(var.vpc_cidr, 8, count.index + length(aws_subnet.public_subnets) + 1)
  availability_zone_id = data.aws_availability_zones.az.zone_ids[count.index]

  tags = merge(local.tags, { Name = "privSub-${count.index + 1}-${var.tag_name}" })
  depends_on = [
    aws_vpc.vpc_cfg
  ]
}

#NAT GATEWAY

resource "aws_eip" "miIP" {

  vpc = true

  tags = merge(local.tags, { Name = "IPNatGTW-${var.tag_name}" })

  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.miIP.allocation_id
  subnet_id     = aws_subnet.public_subnets[0].id

  tags = merge(local.tags, { Name = "NatGTW-${var.tag_name}" })

  depends_on = [aws_internet_gateway.igw, aws_eip.miIP]
}

# CREATE PRIVATE ROUTE TABLE
resource "aws_route_table" "rt_private" {
  vpc_id = aws_vpc.vpc_cfg.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = merge(local.tags, { Name = "PrivRouteTable-${var.tag_name}" })

  depends_on = [
    aws_subnet.private_subnets,
    aws_nat_gateway.natgw
  ]

}

# JOIN PRIVATE SUBNETS WITH PRIVATE ROUTE TABLE

resource "aws_route_table_association" "private_asoc" {
  count          = length(data.aws_availability_zones.az.zone_ids)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.rt_private.id

  depends_on = [
    aws_subnet.private_subnets,
    aws_route_table.rt_private
  ]
}

#########################################################################################

# SECURITY GROUP AVAILABLES IN THE VPC

#########################################################################################

# SECURITY GROUP FOR EC2 INSTANCES

resource "aws_security_group" "sg_ec2_allow_ssh" {
  name        = "Allow ssh trafic"
  description = "Allow SSH trafic"
  vpc_id      = aws_vpc.vpc_cfg.id

  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.tags, { Name = "sg_allow_ssh_ec2-${var.tag_name}" })

  depends_on = [
    aws_vpc.vpc_cfg
  ]
}

resource "aws_security_group" "sg_elb" {
  name        = "Allow web trafic"
  description = "Allow web trafic"
  vpc_id      = aws_vpc.vpc_cfg.id

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.tags, { Name = "sg_elb-${var.tag_name}" })

  depends_on = [
    aws_vpc.vpc_cfg
  ]
}

resource "aws_security_group" "sg_ec2" {
  name        = "Allow necesary trafic in backend ec2"
  description = "Allow NFS, SSH, HTTPS and HTTP trafic"
  vpc_id      = aws_vpc.vpc_cfg.id


  ingress {
    description     = "HTTPS"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_elb.id, aws_security_group.sg_ec2_allow_ssh.id]
  }

  ingress {
    description     = "HTTP"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_elb.id, aws_security_group.sg_ec2_allow_ssh.id]
  }

  ingress {
    description     = "SSH"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_ec2_allow_ssh.id]
  }

  ingress {
    description      = "NFS"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.tags, { Name = "sg_ec2-${var.tag_name}" })

  depends_on = [
    aws_vpc.vpc_cfg,
    aws_security_group.sg_elb,
    aws_security_group.sg_ec2_allow_ssh
  ]
}

# SECURITY GROUP FOR EFS

resource "aws_security_group" "sg_efs" {
  name        = "Allow NFS"
  description = "Allow only NFS trafic"
  vpc_id      = aws_vpc.vpc_cfg.id

  ingress {
    description     = "NFS"
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_ec2.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(local.tags, { Name = "sg_efs-${var.tag_name}" })

  depends_on = [
    aws_vpc.vpc_cfg,
    aws_security_group.sg_ec2
  ]
}
