# ---------------------------------------------------------------------------------------------------------------------
# OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

# output "ipaccesslist" {
#   value = mongodbatlas_project_ip_access_list.ip.ip_address
# }

output "db_username_id" {
 value = mongodbatlas_database_user.db_user.id 
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

# output "replication_specs" {
#   description = "Set of replication specifications for the cluster"
#   value = mongodbatlas_advanced_cluster.atlas-cluster.replication_specs
# }

output "db_username" {
 value = mongodbatlas_database_user.db_user.username
}

output "num_of_shards" {
 value = mongodbatlas_advanced_cluster.atlas-cluster.replication_specs[0].num_shards
}

output "network_peering_endpoint" {
 value = mongodbatlas_advanced_cluster.atlas-cluster.connection_strings
}

output db_passsword {
  value     = random_password.mongo-user-pwd.result
  sensitive = true
}

output cidr_block {
  value     = mongodbatlas_network_peering.test.atlas_cidr_block
}

output vpc_peering_conection_status {
  description = "Status of the Atlas network peering connection"
  value     = mongodbatlas_network_peering.test.status
}

# output network_peering_container_id {
#   description = "Status of the Atlas network peering connection"
#   value     = mongodbatlas_network_peering.test.container_id
# }

output network_peer {
  description = "Name of the network peer to which Atlas connects."
  value     = mongodbatlas_network_peering.test.network_name
}

output atlas_gcp_project_id {
  description = "The Atlas GCP Project ID for the GCP VPC used by your atlas cluster that it is need to set up the reciprocal connection"
  value     = mongodbatlas_network_peering.test.atlas_gcp_project_id
}

output gcp_project_id {
  description = "GCP project ID of the owner of the network peer"
  value     = mongodbatlas_network_peering.test.gcp_project_id
}

output ip_access_list {
  description = "GCP project ID of the owner of the network peer"
  value     = mongodbatlas_project_ip_access_list.atlas-whitelist.cidr_block
}

output cidr_from_gcp {
  description = "The gateway address for default routing out of the network. This value is selected by GCP."
  value     = mongodbatlas_project_ip_access_list.atlas-whitelist.cidr_block
}

output "connection_strings" {
  value = mongodbatlas_advanced_cluster.atlas-cluster.connection_strings
}

