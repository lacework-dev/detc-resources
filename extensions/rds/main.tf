variable "vpc_id" {}
variable "subnet1" {}
variable "subnet2" {}
variable "username" {}
variable "password" {}

resource "aws_db_subnet_group" "db_subnet_group" {
  name       = "rds"
  subnet_ids = [var.subnet1, var.subnet2]
  tags = {
    Name = "Jenkins"
  }
}

resource "aws_db_parameter_group" "db_parameter_group" {
  name   = "rds"
  family = "postgres14"
  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_security_group" "rds" {
  name   = "ds"
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

  tags = {
    Name = "rds"
  }
}

resource "aws_db_instance" "rds" {
  identifier             = "rds"
  instance_class         = "db.t3.micro"
  allocated_storage      = 5
  engine                 = "postgres"
  engine_version         = "14.1"
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.db_parameter_group.name
  publicly_accessible    = false
  skip_final_snapshot    = true
}

output "address" {
  value = aws_db_instance.rds.address
}

output "port" {
  value = aws_db_instance.rds.port
}