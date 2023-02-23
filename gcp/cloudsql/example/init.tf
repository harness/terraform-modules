terraform {
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = ">= 4.44.0"
    }
  }

  required_version = ">= 1.3.0, < 1.3.9"
}

provider "google" {
  project = "sre-play"
#  credentials = "/opt/harness-delegate/srv_admin.json"
}
