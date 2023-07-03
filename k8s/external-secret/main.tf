provider "google" {
  project = var.project
  region  = var.region
}

data "google_client_config" "default" {}

data "google_container_cluster" "default" {
  name     = var.cluster
  project  = var.project
  location = var.region
}

module "cluster_ca_certificate" {
  source      = "git::https://github.com/harness/terraform-modules.git//gcp/secret-read"
  context     = module.this.context
  description = "cluster-ca-certificate"
  namespace   = ""
  project     = var.project
  region      = var.region
}

provider "kubectl" {
  host                   = "https://${data.google_container_cluster.default.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.cluster_ca_certificate.data)
}

provider "kubernetes" {
  host                   = "https://${data.google_container_cluster.default.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.cluster_ca_certificate.data)
}

resource "kubectl_manifest" "external-secret" {
  yaml_body = templatefile("${path.module}/ExternalSecret.yaml", {
    secretName = var.secretName
    secretNamespace = var.secretNamespace
    clusterSecretStore = var.clusterSecretStore
    secretType = var.secretType 
    secretTemplate = var.secretTemplate
    secretDataRef = var.secretDataRef
  })
}