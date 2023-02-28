terraform {
  required_providers {

    google = {
      source  = "hashicorp/google"
      version = ">= 4.44.0"
    }
  }
}


provider "google" {
  project = "sre-play"
#  credentials = "/opt/harness-delegate/srv_admin.json"
}