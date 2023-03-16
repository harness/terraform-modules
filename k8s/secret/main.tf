provider "kubernetes" {
    host = var.cluster_endpoint

    client_certificate = var.client_certificate
    client_key = var.client_key
    cluster_ca_certificate = var.cluster_ca_certificate
}

resource "kubernetes_secret" "this" {
    metadata {
        name = var.name
    }

    data = var.data
    type = var.type
}
