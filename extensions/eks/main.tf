variable "aws_region" {
  description = "AWS region.  Example: us-east-2"
}

variable "cluster_name" {
  description = "Name of the EKS cluster.  Example: rotate"
}

variable "enable_imds_v1" {
  description = "enable the use of IMDSv1"
  default     = "false"
}

variable "enable_ebs_csi" {
  description = "enable EBS CSI driver for PV"
  default     = "false"
}

variable "iam_role_additional_policies" {
  description = "additional iam policies to attach to the worker nodes, comma separated"
  default     = ""
}

variable "managed_nodes_iam_role" {
  default = ""
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "cluster_tags" {
  type = map(string)
  default = {}
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 4.42"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.10"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
  }

  required_version = "> 0.14"
}

provider "aws" {
  region = var.aws_region
}

locals {
  cluster_name       = "eks-demo-${var.cluster_name}"
  http_tokens        = var.enable_imds_v1 == "true" ? "optional" : "required"
  extra_iam_policies = split(",", var.iam_role_additional_policies)
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.26.5"
  cluster_name    = local.cluster_name
  cluster_version = "1.23"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = var.tags
  cluster_tags = var.cluster_tags

  eks_managed_node_group_defaults = {
    disk_size      = 50
    instance_types = ["t2.medium"]
    tags = var.tags
    metadata_options = {
      http_tokens = local.http_tokens
    }
  }

  cluster_addons = var.enable_ebs_csi == "true" ? {
    aws-ebs-csi-driver = {
      most_recent = true
    }
  } : {}

  eks_managed_node_groups = {
    primary = {
      vpc_security_group_ids = [aws_security_group.all_worker_mgmt.id]
      tags = var.tags
      min_size               = 1
      desired_size           = 2
      max_size               = 10
      create_iam_role        = var.managed_nodes_iam_role == "" ? true : false
      iam_role_arn           = var.managed_nodes_iam_role == "" ? "" : var.managed_nodes_iam_role
      iam_role_additional_policies = var.enable_ebs_csi && var.managed_nodes_iam_role == "" ? concat([
        "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
      ], local.extra_iam_policies) : local.extra_iam_policies
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = 0
    to_port   = 0
    protocol  = -1
    self      = true
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                       = "${local.cluster_name}-vpc"
  cidr                       = "10.0.0.0/16"
  azs                        = data.aws_availability_zones.available.names
  private_subnets            = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets             = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  enable_nat_gateway         = true
  single_nat_gateway         = true
  enable_dns_hostnames       = true
  manage_default_network_acl = true

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}

