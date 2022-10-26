variable "region" {
  description = "GCP region"
}

variable "project" {
  description = "Name of google project id. Example: test-123456"
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

resource "google_project_service" "enable-compute" {
  project = var.project
  service = "compute.googleapis.com"
}

resource "google_project_service" "enable-k8s" {
  project = var.project
  service = "container.googleapis.com"
}

resource "google_project_service" "enable-cloudresourcemanager" {
  project = var.project
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_service_account" "service_account" {
  display_name = "detc_management_account"
  project      = var.project
  account_id   = "detc-management-account"
}

resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.name
}

resource "google_project_iam_member" "service-account-iam" {
  project = var.project
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}

output "service_account" {
  value     = base64decode(google_service_account_key.service_account_key.private_key)
  sensitive = true
}
