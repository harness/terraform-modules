/*
provider "google" {
  project = var.project
  region  = var.region
}
*/

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
