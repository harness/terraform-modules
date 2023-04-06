provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}

data "google_client_config" "default" {}

data "google_container_cluster" "default" {
  name     = var.gke_cluster_name
  project  = var.gcp_project
  location = var.gcp_region
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.default.endpoint}"
  token = data.google_client_config.default.access_token
  #cluster_ca_certificate = base64decode(
  #  data.google_container_cluster.default.master_auth[0].cluster_ca_certificate,
  #)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}
resource "kubernetes_secret" "this" {
  count = var.enabled ? 1 : 0
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  data = var.data
  type = var.type
}
