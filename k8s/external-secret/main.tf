resource "kubectl_manifest" "external-secret" {
  count = var.enabled ?  1 : 0
  yaml_body = templatefile("${path.module}/ExternalSecret.yaml", {
    secretName = var.secretName
    secretNamespace = var.secretNamespace
    clusterSecretStore = var.clusterSecretStore
    secretType = var.secretType 
    secretTemplate = var.secretTemplate
    secretDataRef = var.secretDataRef
  })
}
