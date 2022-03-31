variable "vpc_id" {}
variable "subnet" {}
variable "instance_name" {}
variable "ports" {
  default = "22"
}

resource "tls_private_key" "keypair" {
  algorithm = "RSA"
}

resource "aws_key_pair" "server-key" {
  key_name   = "${var.instance_name}-server-key"
  public_key = tls_private_key.keypair.public_key_openssh
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  split_ports = split(",", var.ports)
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
  tags = {
    "Hostname" = "${var.instance_name}"
  }
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.medium"
  associate_public_ip_address = true
  subnet_id                   = var.subnet
  vpc_security_group_ids      = [aws_security_group.ingress-from-all.id]

  key_name   = "${var.instance_name}-server-key"
  depends_on = [aws_key_pair.server-key, aws_security_group.ingress-from-all]
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
