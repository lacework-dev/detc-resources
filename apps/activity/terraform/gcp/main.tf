terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.39.1"
    }
  }
}

variable "project" {
  description = "Name of google project id. Example: gke-cluster-test-123456"
}

# Setup SAs for making noise
resource "google_service_account" "service_account" {
  for_each     = toset(["charlie", "frank", "deandra"])
  project      = var.project
  account_id   = "${each.value}-sa"
  display_name = each.value
}

resource "google_service_account_key" "service_account_key" {
  for_each           = google_service_account.service_account
  service_account_id = each.value.name
}

resource "google_project_iam_member" "service-account-iam" {
  for_each = google_service_account.service_account
  project  = var.project
  role     = "roles/editor"
  member   = "serviceAccount:${each.value.email}"
}

locals {
  creds = merge({
    for k, v in google_service_account.service_account : k => tomap({
      name : v.name
      key : base64decode(google_service_account_key.service_account_key[k].private_key)
    })
  })
}

output "creds" {
  value     = local.creds
  sensitive = true
}
