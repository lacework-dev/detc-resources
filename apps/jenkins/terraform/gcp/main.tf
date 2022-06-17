terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.52.0"
    }
  }
}

data "google_client_config" "this" {}
locals {
  project = data.google_client_config.this.project
}


resource "google_service_account" "jenkins_service_account" {
  project      = local.project
  account_id   = "jenkins-sa"
  display_name = "jenkins-sa"
}

resource "google_service_account_key" "jenkins_service_account_key" {
  service_account_id = google_service_account.jenkins_service_account.id
}

resource "google_project_iam_member" "jenkins_service-account-iam" {
  project = local.project
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.jenkins_service_account.email}"
}

output "email" {
  value = google_service_account.jenkins_service_account.email
}

output "credentials" {
  value     = base64decode(google_service_account_key.jenkins_service_account_key.private_key)
  sensitive = true
}
