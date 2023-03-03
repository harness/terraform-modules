provider "google" {
    project = var.project
    region = var.region
}

resource "google_project_service" "secretmanager" {
    provider = google
    service = "secretmanager.googleapis.com"
}

data "google_secret_manager_secret_version" "this" {
    secret = var.name
}

output "data" {
    value = data.google_secret_manager_secret_version.this.secret
}