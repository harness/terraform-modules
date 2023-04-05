provider "google" {
    project = var.project
    region = var.region
}


resource "google_secret_manager_secret" "this" {
    count = var.enabled ? 1 : 0
    secret_id = var.name 
    labels = var.labels   
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
    count = var.enabled ? 1 : 0
    secret = google_secret_manager_secret[0].this.id 
    secret_data = var.data
}
