locals {
  enabled          = module.this.enabled
  create_namespace = local.enabled && (var.create_namespace == true)
}

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

resource "kubernetes_namespace" "this" {
  count = local.create_namespace ? 1 : 0
  metadata {
    name        = var.kubernetes_namespace
    annotations = var.kubernetes_namespace_annotations
    labels      = var.kubernetes_namespace_labels
  }
}

provider "helm" {
  kubernetes {
    host  = "https://${data.google_container_cluster.default.endpoint}"
    client_certificate =  base64decode(data.google_container_cluster.default.master_auth[0].client_certificate)
    client_key = data.google_container_cluster.default.master_auth[0].client_key
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  }
}

resource "helm_release" "this" {
  count = local.enabled ? 1 : 0

  name = coalesce(var.release_name, module.this.name, var.chart)

  chart       = var.chart
  description = var.description
  devel       = var.devel
  version     = var.chart_version

  repository           = var.repository
  repository_ca_file   = var.repository_ca_file
  repository_cert_file = var.repository_cert_file
  repository_key_file  = var.repository_key_file
  repository_password  = var.repository_password
  repository_username  = var.repository_username

  namespace = var.kubernetes_namespace

  atomic                     = var.atomic
  cleanup_on_fail            = var.cleanup_on_fail
  dependency_update          = var.dependency_update
  disable_openapi_validation = var.disable_openapi_validation
  disable_webhooks           = var.disable_webhooks
  force_update               = var.force_update
  keyring                    = var.keyring
  lint                       = var.lint
  max_history                = var.max_history
  recreate_pods              = var.recreate_pods
  render_subchart_notes      = var.render_subchart_notes
  replace                    = var.replace
  reset_values               = var.reset_values
  reuse_values               = var.reuse_values
  skip_crds                  = var.skip_crds
  timeout                    = var.timeout
  values                     = var.values
  verify                     = var.verify
  wait                       = var.wait
  wait_for_jobs              = var.wait_for_jobs

  dynamic "set" {
    for_each = var.set
    content {
      name  = set.value["name"]
      value = set.value["value"]
      type  = set.value["type"]
    }
  }

  dynamic "set_sensitive" {
    for_each = var.set_sensitive
    content {
      name  = set_sensitive.value["name"]
      value = set_sensitive.value["value"]
      type  = set_sensitive.value["type"]
    }
  }

  dynamic "postrender" {
    for_each = var.postrender_binary_path != null ? [1] : []

    content {
      binary_path = var.postrender_binary_path
    }
  }
}
