variable "name" {}

variable "subnet" {
  default = "10.0.0.0/24"
}
variable "subnet1" {
  default = "10.0.1.0/24"
}
variable "cidr_block" {
  default = "10.0.0.0/16"
}

provider "aws" {}
data "aws_region" "current" {}

resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.name}_vpc"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet
  availability_zone       = "${data.aws_region.current.name}a"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.name}_subnet"
  }
}

resource "aws_subnet" "subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.subnet1
  map_public_ip_on_launch = "true"
  availability_zone       = "${data.aws_region.current.name}b"
  tags = {
    Name = "${var.name}_subnet1"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.name}_igw"
  }
}

resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "default route table"
  }
}

output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "subnet_id1" {
  value = aws_subnet.subnet.id
}

output "subnet_id2" {
  value = aws_subnet.subnet1.id
}
