output "id" {
    description = "ID of cluster created"
    value = google_container_cluster.primary.id
}

output "endpoint" {
    description = "Endpoint for cluster"
    value = google_container_cluster.primary.endpoint
}