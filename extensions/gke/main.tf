variable "region" {
  description = "GKE cluster region"
}

variable "project" {
  description = "Name of google project id. Example: gke-cluster-test-123456"
}

variable "cluster_name" {
  description = "Name of the gke cluster. Example: gke-cluster-foo"
}

variable cluster_labels {
  type = map(string)
  default = {}
}

variable nodes_labels {
  type = map(map(string))
  default = {
    all = {}

    default-node-pool = {
      default-node-pool = true
    }
  }
}

variable "tags" {
  type = map(string)
  default = {}
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.39.1"
    }
  }

  required_version = "> 0.14"
}

provider "google" {
  project = var.project
  region  = var.region
}

module "gke" {
  source              = "terraform-google-modules/kubernetes-engine/google"
  version             = "31.1.0"
  project_id          = var.project
  name                = var.cluster_name
  region              = var.region
  network             = "${var.project}-vpc"
  subnetwork          = module.vpc.subnets_names[0]
  ip_range_pods       = "${var.project}-ip-range-pods-name"
  ip_range_services   = "${var.project}-ip-range-services-name"
  release_channel     = "UNSPECIFIED"
  deletion_protection = false

  cluster_resource_labels = var.cluster_labels
  node_pools_labels = var.nodes_labels

  node_pools = [
    {
      name : "default-node-pool"
      auto_upgrade : false
    }
  ]
}

module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "9.1.0"

  project_id   = var.project
  network_name = "${var.project}-vpc"

  subnets = [
    {
      subnet_name   = "${var.project}-subnetwork"
      subnet_ip     = "10.0.0.0/22"
      subnet_region = var.region
    }
  ]

  secondary_ranges = {
    ("${var.project}-subnetwork") = [
      {
        range_name    = "${var.project}-ip-range-pods-name"
        ip_cidr_range = "192.168.0.0/22"
      },
      {
        range_name    = "${var.project}-ip-range-services-name"
        ip_cidr_range = "192.168.64.0/22"
      }
    ]
  }
}

module "gke_auth" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/auth"
  depends_on = [module.gke]
  version    = "31.1.0"

  project_id           = var.project
  cluster_name         = var.cluster_name
  location             = module.gke.location
  use_private_endpoint = false
}
