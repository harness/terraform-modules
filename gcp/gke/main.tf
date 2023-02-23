provider "google" {
  project = var.project
  region = var.region
}

resource "google_service_account" "default" {
  account_id   = "gke-cluster"
  display_name = "GKE Service Account"
}

resource "google_container_cluster" "primary" {
  name     = var.name 
  location = var.region

  remove_default_node_pool = false
  initial_node_count       = 1

  #enable_autopilot = var.enable_autopilot

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.authorized_networks

      content {
        cidr_block = cidr_blocks.value
        display_name = cidr_blocks.key
      }
    }
  }

  node_config {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.default.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"    
    ]
  }

  timeouts {
    create = "30m"
    update = "40m"
  }
}

