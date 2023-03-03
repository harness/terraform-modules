terraform {
  required_providers {

    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = "1.4.6"
    }
  }

}

provider "mongodbatlas" {
  public_key = "wcwdwbsg"
  private_key = "9907b31f-7461-4746-bccd-ed07fb6a5bc2"
}


provider "google" {
  project = "sre-play"
#  credentials = "/opt/harness-delegate/srv_admin.json"
}

output "connection_strings" {
  value = ["${mongodbatlas_advanced_cluster.atlas-cluster.connection_strings}"]
}