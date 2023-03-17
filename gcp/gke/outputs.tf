# ---------------------------------------------------------------------------------------------------------------------
# OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

output "cluster_endpoint" {
 value = google_container_cluster.primary.endpoint
}

output "client_certificate" {
 value = google_container_cluster.primary.master_auth.0.client_certificate
}

output "client_key" {
 value = google_container_cluster.primary.master_auth.0.client_key
 sensitive = true
}

output "cluster_ca_certificate" {
 value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}

output "self_link" {
<<<<<<< Updated upstream
    value = google_container_cluster.primary.self_link
}

output "endpoint" {
    description = "Endpoint for cluster"
    value = google_container_cluster.primary.endpoint
}

output "cluster_endpoint" {
 value = google_container_cluster.primary.endpoint
}

output "client_certificate" {
 value = google_container_cluster.primary.master_auth.0.client_certificate
}

output "client_key" {
 value = google_container_cluster.primary.master_auth.0.client_key
 sensitive = true
}

output "cluster_ca_certificate" {
 value = google_container_cluster.primary.master_auth.0.cluster_ca_certificate
}
=======
 value = google_container_cluster.primary.self_link
}
>>>>>>> Stashed changes
