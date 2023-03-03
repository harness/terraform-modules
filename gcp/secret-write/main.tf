provider "google" {
    project = var.project
    region = var.region
}

resource "google_project_service" "secretmanager" {
    provider = google
    service = "secretmanager.googleapis.com"
}

resource "google_secret_manager_secret" "this" {
    secret_id = var.name 
    labels = var.labels   
}

resource "google_secret_manager_secret_version" "this" {
    secret = google_secret_manager_secret.this.id 
    secret_data = var.data
}