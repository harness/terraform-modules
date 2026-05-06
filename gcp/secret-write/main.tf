terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}

module "labels" {
  source           = "git::https://github.com/harness/terraform-modules.git//label"
  context          = module.this.context
  label_key_case   = "lower"
  label_value_case = "lower"
  id_length_limit  = 63
}

resource "google_secret_manager_secret" "this" {
  count     = module.this.enabled ? 1 : 0
  secret_id = module.this.id

  ## labels in gcp MUST be lower case, hence the use of the label module
  labels  = module.labels.tags
  project = var.project

  dynamic "replication" {
    for_each = var.replication_policy == "automatic" ? [1] : []
    content {
      automatic = true
    }
  }

  dynamic "replication" {
    for_each = var.replication_policy == "user_managed" ? [1] : []
    content {
      user_managed {
        dynamic "replicas" {
          for_each = var.replica_locations
          content {
            location = replicas.value
          }
        }
      }
    }
  }
}

resource "google_secret_manager_secret_version" "this" {
  count       = module.this.enabled ? 1 : 0
  secret      = google_secret_manager_secret.this[0].id
  secret_data = var.data
}
