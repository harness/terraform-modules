provider "google" {
  project = var.project
  region  = var.region
}


resource "google_secret_manager_secret" "this" {
  count     = module.this.enabled ? 1 : 0
  secret_id = module.this.id
  labels    = module.this.tags
  replication {
    user_managed {
      replicas {
        location = "us-central1"
      }
      replicas {
        location = "us-east1"
      }
    }
  }
}

resource "google_secret_manager_secret_version" "this" {
  count       = module.this.enabled ? 1 : 0
  secret      = google_secret_manager_secret.this[0].id
  secret_data = var.data
}
