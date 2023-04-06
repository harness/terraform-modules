provider "google" {
    project = var.gcp_project
    region = var.gcp_region
}

data "google_client_config" "provider" {}

data "google_container_cluster" "cluster" {
  name      = var.gke_cluster_name
  project   = var.gcp_project
  location  = var.gcp_region
}

provider "kubernetes" {
    token = data.google_client_config.provider.access_token

    host = format("%s%s", "https://", data.google_container_cluster.cluster.endpoint)
    cluster_ca_certificate = data.google_container_cluster.cluster.master_auth.0.ca_certificate
    client_key = data.google_container_cluster.cluster.master_auth.0.client_key
    client_certificate = data.google_container_cluster.cluster.master_auth.0.client_certificate
}
resource "kubernetes_secret" "this" {
    count = var.enabled ? 1 : 0
    metadata {
        name = var.name
        namespace = var.namespace
    }

    data = var.data
    type = var.type
}
