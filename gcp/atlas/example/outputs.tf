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
