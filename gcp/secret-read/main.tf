/*
provider "google" {
  project = var.project
  region  = var.region
}
*/

data "google_secret_manager_secret_version" "this" {
  count  = module.this.enabled ? 1 : 0
  secret = module.this.id
}

output "data" {
  value = one(data.google_secret_manager_secret_version.this[*].secret_data)
}
