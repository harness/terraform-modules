terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

data "google_secret_manager_secret_version" "this" {
  count  = module.this.enabled ? 1 : 0
  secret = module.this.id
  project = var.project
}

output "data" {
  description = "The secret data retrieved from Google Secret Manager"
  value       = one(data.google_secret_manager_secret_version.this[*].secret_data)
  sensitive   = true
}
