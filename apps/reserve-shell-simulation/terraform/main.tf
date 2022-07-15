variable "cluster_arn" {}
variable "service_subnet" {}
variable "vpc_id" {}
variable "aws_region" {}
variable "lacework_access_token" {}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22.0"
    }
  }

  required_version = "> 0.14"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "ingress-from-all" {
  name   = "reverseshell-ingress-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "open port 8080"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  envs = [{
    "name" : "LaceworkAccessToken"
    "value" : var.lacework_access_token
  }]
}

resource "aws_ecs_task_definition" "reverseshell" {
  family                   = "service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  container_definitions    = <<DEFINITION
    [{
      "name": "reverseshell",
      "image": "public.ecr.aws/f9l6s8l3/nodejs-reverse-shell:latest",
      "essential": true,
      "environment": ${jsonencode(local.envs)}
    }]
  DEFINITION
  cpu                      = 256
  memory                   = 512
}

resource "aws_ecs_service" "reverseshell" {
  name                  = "reverseshell"
  cluster               = var.cluster_arn
  task_definition       = aws_ecs_task_definition.reverseshell.arn
  desired_count         = 1
  wait_for_steady_state = true

  network_configuration {
    subnets          = [var.service_subnet]
    security_groups  = [aws_security_group.ingress-from-all.id]
    assign_public_ip = true
  }
}

output "service" {
  value = aws_ecs_service.reverseshell
}
