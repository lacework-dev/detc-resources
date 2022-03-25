variable "region" {
  description = "GCP region"
}

variable "project" {
  description = "Name of google project id. Example: test-123456"
}

variable "instance_name" {
  description = "Instance name"
}

variable "tags" {
  default = ""
}

provider "tls" {
}


locals {
  split_tags = split(",", var.tags)
  local_tags = compact(local.split_tags)
}


resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }

  required_version = "> 0.14"
}
provider "google" {
  project = var.project
  region  = var.region
}

resource "google_compute_address" "static" {
  name = "ipv4-address"
}

resource "google_compute_instance" "instance-server" {
  name         = var.instance_name
  machine_type = "e2-small"
  zone         = "${var.region}-b"
  tags         = local.local_tags

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.ssh.public_key_openssh}"
  }


  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}

output "ip" {
  value = google_compute_address.static.address
}

output "ssh_key" {
  value     = tls_private_key.ssh.private_key_pem
  sensitive = true
}
