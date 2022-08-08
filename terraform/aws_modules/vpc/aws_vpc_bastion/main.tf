# module: bastion

# creates a bastion host in a service subnet, fronted by a public elb

locals {
  bastion_tags = {
    inputs = {
      "Name" = "bastion.${var.cluster_name}"
    }
  }
}

# gets a list of public subnets, up to the number of AZs specified
data "aws_subnet" "public_subnets" {
  count = var.num_az
  id    = element(var.public_subnets, count.index)
}

# gets a list of service subnets, up to the number of AZs specified
data "aws_subnet" "services_subnets" {
  count = var.num_az
  id    = element(var.services_subnets, count.index)
}

# gets the ami id for centos 7
data "aws_ami" "centos" {
  most_recent = true
  owners      = [679593333241]

  filter {
    name   = "description"
    values = ["CentOS Linux 7 x86_64 HVM EBS 1602"]
  }
}

resource "tls_private_key" "key" {
  count     = var.enable_bastion
  algorithm = "RSA"
}

# creates an ec2 key with the contents of the previously generated pub key specified
resource "aws_key_pair" "key" {
  count      = var.enable_bastion
  key_name   = "bastion-${var.cluster_name}"
  public_key = tls_private_key.key[0].public_key_openssh
}

# security group to allow ssh in to the bastion from the elb
resource "aws_security_group" "ssh" {
  count       = var.enable_bastion
  name        = "bastion.ssh.${var.cluster_name}"
  description = "Allow SSH from bastion ELB to bastion instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.elb[0].id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = merge(
    var.identifier_tags,
    local.bastion_tags.inputs,
  )
}

# security group to allow ssh in to the elb from the internet
resource "aws_security_group" "elb" {
  count       = var.enable_bastion
  name        = "bastion.elb.ssh.${var.cluster_name}"
  description = "Allow SSH from the Internet to the Bastion ELB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    self        = true
  }

  tags = merge(
    var.identifier_tags,
    local.bastion_tags.inputs,
  )
}

# launch configuration for the 1/1 asg
resource "aws_launch_configuration" "bastion" {
  count         = var.enable_bastion
  name_prefix   = "bastion.${var.cluster_name}."
  image_id      = data.aws_ami.centos.image_id
  instance_type = var.instance_type

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 8
    delete_on_termination = true
  }

  associate_public_ip_address = false

  security_groups = [
    aws_security_group.ssh[0].id,
  ]

  key_name = aws_key_pair.key[0].key_name

  lifecycle {
    create_before_destroy = true
  }
}

# auto scaling group for the bastion host
resource "aws_autoscaling_group" "bastion" {
  count = var.enable_bastion

  name = "bastion-${var.cluster_name}-${element(
    data.aws_subnet.services_subnets.*.availability_zone,
    count.index,
  )}-${element(aws_launch_configuration.bastion.*.name, count.index)}"

  launch_configuration = element(aws_launch_configuration.bastion.*.id, count.index)

  availability_zones = [element(
    data.aws_subnet.services_subnets.*.availability_zone,
    count.index,
  )]
  vpc_zone_identifier = [element(data.aws_subnet.services_subnets.*.id, count.index)]

  load_balancers    = [aws_elb.bastion[0].name]
  health_check_type = "ELB"
  min_elb_capacity  = 1

  min_size = 1
  max_size = 1

  tag {
    key                 = "Name"
    value               = "bastion.${var.cluster_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "Team"
    value               = var.identifier_tags["Team"]
    propagate_at_launch = true
  }

  tag {
    key                 = "Owner"
    value               = var.identifier_tags["Owner"]
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

# public elb in front of the bastion instance
resource "aws_elb" "bastion" {
  count           = var.enable_bastion
  name            = format("%.32s", replace("bastion-${var.cluster_name}", "-", ""))
  subnets         = data.aws_subnet.public_subnets.*.id
  security_groups = [aws_security_group.elb[0].id]
  internal        = false

  listener {
    instance_port     = 22
    instance_protocol = "TCP"
    lb_port           = 22
    lb_protocol       = "TCP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 3
    timeout             = 3
    target              = "TCP:22"
    interval            = 30
  }

  tags = merge(
    var.identifier_tags,
    local.bastion_tags.inputs,
  )
}

# creates a route53 record pointing to the bastion elb
resource "aws_route53_record" "bastion" {
  count   = var.enable_bastion
  name    = "bastion"
  zone_id = var.route53_zone_id
  ttl     = "30"
  type    = "CNAME"

  records = [
    aws_elb.bastion[0].dns_name,
  ]
}

