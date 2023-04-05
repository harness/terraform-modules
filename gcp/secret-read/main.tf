provider "google" {
    project = var.project
    region = var.region
}

data "google_secret_manager_secret_version" "this" {
    count = var.enabled ? 1 : 0
    secret = var.name
}

output "data" {
    value = data.google_secret_manager_secret_version.this[0].secret_data
}
