provider "google" {
    project = var.gcp_project_id
    region = var.gcp_region
}

data "google_container_cluster" "my_cluster" {
  name     = var.gcp_project_id
  location = var.gcp_region
}

provider "kubernetes" {
    host = var.cluster_endpoint
    client_certificate = data.google_container_cluster.my_cluster.client_certificate
    client_key = data.google_container_cluster.my_cluster.client_key
    cluster_ca_certificate = var.cluster_ca_certificate
}

resource "kubernetes_secret" "this" {
    metdata {
        name = var.name
    }

    data = var.data
    type = var.type
}