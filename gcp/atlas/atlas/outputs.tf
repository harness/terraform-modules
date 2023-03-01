# ---------------------------------------------------------------------------------------------------------------------
# OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

# output "ipaccesslist" {
#   value = mongodbatlas_project_ip_access_list.ip.ip_address
# }

output "db_username" {
 value = mongodbatlas_database_user.db_user.id // should be "username", but it's YXV0aF9kYXRhYmFzZV9uYW1l:YWRtaW4=-cHJvamVjdF9pZA==:NWZhZDUwODM5YTFlZmIyYzRkMzdhYzI3-dXNlcm5hbWU=:ZmFicmljYXRvcg==
}

output "connection_strings" {
  value = mongodbatlas_advanced_cluster.atlas-cluster.connection_strings[0].standard_srv
}

output "cluster_id" {
  description = "The cluster ID."
  value = mongodbatlas_advanced_cluster.atlas-cluster.cluster_id
}

output "mongo_db_version" {
  description = "Version of MongoDB the cluster runs"
  value = mongodbatlas_advanced_cluster.atlas-cluster.mongo_db_version
}

output "id" {
  description = "The Terraform's unique identifier used internally for state management."
  value = mongodbatlas_advanced_cluster.atlas-cluster.id
}

output "state_name" {
  description = "Current state of the cluster."
  value = mongodbatlas_advanced_cluster.atlas-cluster.state_name
}

output "replication_specs" {
  description = "Set of replication specifications for the cluster"
  value = mongodbatlas_advanced_cluster.atlas-cluster.replication_specs
}
