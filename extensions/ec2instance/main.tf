variable "vpc_id" {}
variable "subnet" {}
variable "instance_name" {}
variable "ports" { default = "22" }
variable "security_group_arns" { default = "" }
variable "instance_profile_arn" { default = "" }
variable "instance_type" { default = "t2.medium" }
variable "public_ip" { default = true }
variable "root_vol_size" { default = 40 }
variable "tags" {
  type = map(string)
  default = {}
}
variable "ami_type" { default = "ubuntu" }
variable "region" {
  default = ""
}
variable "ssh_public_key" {
  default = ""
}

provider "aws" {
  region = var.region
}

locals {
  ami_data = {
    "ubuntu" : {
      "username" : "ubuntu"
      "name_filter" : ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
      "owners" : ["099720109477"] # Canonical
    }
    "amazonlinux" : {
      "username" : "ec2-user"
      "name_filter" : ["amzn2-ami-hvm*"]
      "owners" : ["amazon"]
    }
  }
  split_ports   = split(",", var.ports)
  split_sg_arns = split(",", var.security_group_arns)
}

resource "tls_private_key" "keypair" {
  algorithm = "RSA"
}

resource "aws_key_pair" "server-key" {
  key_name   = "${var.instance_name}-server-key"
  public_key = var.ssh_public_key != "" ? var.ssh_public_key : tls_private_key.keypair.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = local.ami_data[var.ami_type]["name_filter"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = local.ami_data[var.ami_type]["owners"]
}


resource "aws_security_group" "ingress-from-all" {
  name   = "${var.instance_name}-ingress-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = local.split_ports
    content {
      description = "open port ${ingress.value}"
      from_port   = tonumber(ingress.value)
      to_port     = tonumber(ingress.value)
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "instance-server" {
  tags = merge({"Name" = var.instance_name}, var.tags)
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = tobool(var.public_ip)
  subnet_id                   = var.subnet
  vpc_security_group_ids      = compact(concat([aws_security_group.ingress-from-all.id], local.split_sg_arns))
  iam_instance_profile        = var.instance_profile_arn

  root_block_device {
    volume_size = tonumber(var.root_vol_size)
  }

  key_name   = "${var.instance_name}-server-key"
  depends_on = [aws_key_pair.server-key, aws_security_group.ingress-from-all]
}

output "username" {
  value = local.ami_data[var.ami_type]["username"]
}

output "ip" {
  value = aws_instance.instance-server.public_ip
}

output "pem" {
  value     = tls_private_key.keypair.private_key_pem
  sensitive = true
}

output "sg_id" {
  value = aws_security_group.ingress-from-all.id
}

output "instance_id" {
  value = aws_instance.instance-server.id
}

output "keypair" {
  value = aws_key_pair.server-key.id
}

output "private_ip" {
  value = aws_instance.instance-server.private_ip
}

output "public_key" {
  value = tls_private_key.keypair.public_key_openssh
}

output "ami_type" {
  value = var.ami_type
}

output "ami" {
  value = data.aws_ami.ubuntu.id
}
