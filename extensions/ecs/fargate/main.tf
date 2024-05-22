variable "cluster_name" {}
variable "aws_region" {}
variable "tags" {
  type = map(string)
  default = {}
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
  }

  required_version = "> 0.14"
}

provider "aws" {
  region = var.aws_region
}


resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name
}

resource "aws_ecs_cluster_capacity_providers" "fargate" {
  cluster_name = aws_ecs_cluster.ecs_cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}


output "cluster_arn" {
  value = aws_ecs_cluster.ecs_cluster.arn
}

output "cluster_name" {
  value = var.cluster_name
}

output "cluster_region" {
  value = var.aws_region
}
