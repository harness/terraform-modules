provider "google" {
    project = var.project
    region = var.region
}

data "google_secret_manager_secret_version" "this" {
    secret = var.name
}

output "data" {
    value = data.google_secret_manager_secret_version.this.secret_data
}
