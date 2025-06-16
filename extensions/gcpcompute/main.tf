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
  type = map(string)
  default = {}
}

variable "instance_size" {
  default = "e2-small"
}

provider "tls" {}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
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

resource "google_compute_address" "static" {
  name = "${var.instance_name}-ipv4-address"
}

resource "google_compute_instance" "instance-server" {
  name         = var.instance_name
  machine_type = var.instance_size
  zone         = "${var.region}-b"
  labels       = var.tags

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
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
