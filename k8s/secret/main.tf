provider "google" {
    project = var.gcp_project
    region = var.gcp_region
}

data "google_client_config" "provider" {}

provider "kubernetes" {
    token = data.google_client_config.provider.access_token

    host = var.cluster_endpoint
    client_certificate = base64decode(var.client_certificate)
    client_key = base64decode(var.client_key)
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}
resource "kubernetes_secret" "this" {
    metadata {
        name = var.name
        namespace = var.namespace
    }

    data = var.data
    type = var.type
}
