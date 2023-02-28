variable "vpc_id" {}
variable "subnet1" {}
variable "subnet2" {}
variable "username" {}
variable "password" {}
variable "name" {}
variable "publicly_accessible" { default = false }
variable "tags" { default = "" }


locals {
  new_tags = split(",", var.tags)
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "${var.name}-subnet-grp"
  subnet_ids = [var.subnet1, var.subnet2]
  tags = merge({ "Name" = "${var.name}" }, {
    for t in local.new_tags : element(split("=", t), 0) => element(split("=", t), 1) if t != ""
  })
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "${var.name}-db-param-grp"
  family = "postgres14"
  parameter {
    name  = "log_connections"
    value = "1"
  }
  tags = merge({ "Name" = "${var.name}" }, {
    for t in local.new_tags : element(split("=", t), 0) => element(split("=", t), 1) if t != ""
  })
}

resource "aws_security_group" "rds" {
  name   = "${var.name}-rds-sec-grp"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ "Name" = "${var.name}" }, {
    for t in local.new_tags : element(split("=", t), 0) => element(split("=", t), 1) if t != ""
  })
}

resource "aws_db_instance" "rds" {
  identifier             = var.name
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = true
  tags = merge({ "Name" = "${var.name}" }, {
    for t in local.new_tags : element(split("=", t), 0) => element(split("=", t), 1) if t != ""
  })
}

output "address" {
  value = aws_db_instance.rds.address
}

output "port" {
  value = aws_db_instance.rds.port
}
