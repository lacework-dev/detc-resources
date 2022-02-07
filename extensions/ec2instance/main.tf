variable "vpc_id" {}
variable "subnet" {}
variable "instance_name" {}

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

resource "aws_security_group" "ingress-ssh-from-all" {
  name   = "${var.instance_name}-allow-all-ssh-sg"
  vpc_id = var.vpc_id

  ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
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
  vpc_security_group_ids      = [aws_security_group.ingress-ssh-from-all.id]

  key_name   = "${var.instance_name}-server-key"
  depends_on = [aws_key_pair.server-key, aws_security_group.ingress-ssh-from-all]
}

output "ip" {
  value = aws_instance.instance-server.public_ip
}

output "pem" {
  value     = tls_private_key.keypair.private_key_pem
  sensitive = true
}
