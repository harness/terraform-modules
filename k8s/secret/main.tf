provider "google" {
    project = var.gcp_project_id
    region = var.gcp_region
}
provider "kubernetes" {
    
    username = ""
    password = "" 

    host = var.cluster_endpoint
    client_certificate = base64decode(var.client_certificate)
    client_key = base64decode(var.client_key)
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
}
resource "kubernetes_secret" "this" {
    metadata {
        name = var.name
    }

    data = var.data
    type = var.type
}
