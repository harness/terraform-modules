
# ---------------------------------------------------------------------------------------------------------------------
# This tf project will write output variables to GCP for Mongo Atlas
# ---------------------------------------------------------------------------------------------------------------------


# # ---------------------------------------------------------------------------------------------------------------------
# # WRITE PUBLIC KEY TO GCP
# # ---------------------------------------------------------------------------------------------------------------------
# module "atlas_write_public_key" {
#   source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
#   name          = "atlas_public_key"
#   project       = var.gcp_project
#   region        = var.db_region
#   data          = <>
# }

# # ---------------------------------------------------------------------------------------------------------------------
# # WRITE PRIVATE KEY TO GCP
# # ---------------------------------------------------------------------------------------------------------------------
# module "atlas_write_private_key" {
#   source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
#   name          = "atlas_private_key"
#   project       = var.gcp_project
#   region        = var.db_region
#   data          = <>
# }

# ---------------------------------------------------------------------------------------------------------------------
# WRITING MONGO DB USER TO GCP
# ---------------------------------------------------------------------------------------------------------------------
module "mongo_db_username" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "mongo_db_username"
  project       = var.gcp_project
  region        = var.db_region
  data          = mongodbatlas_database_user.db_user.username
}

# ---------------------------------------------------------------------------------------------------------------------
# WRITING MONGO VERSION INSTALLED OTUPUT TO GCP
# ---------------------------------------------------------------------------------------------------------------------
module "mongo_db_version" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "mongo_db_version"
  project       = var.gcp_project
  region        = var.db_region
  data          = mongodbatlas_advanced_cluster.atlas-cluster.mongo_db_version
}


# ---------------------------------------------------------------------------------------------------------------------
# WRITING MONGO NETWORK PEERING ENDPOINT TO GCP
# ---------------------------------------------------------------------------------------------------------------------
module "network_peering_endpoint" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "network_peering_endpoint"
  project       = var.gcp_project
  region        = var.db_region
  data          = mongodbatlas_advanced_cluster.atlas-cluster.connection_strings.0.standard_srv
}


# ---------------------------------------------------------------------------------------------------------------------
# WRITING MONGO GCP PROJECT ID TO GCP
# ---------------------------------------------------------------------------------------------------------------------
module "atlas_gcp_project_id" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "atlas_gcp_project_id"
  project       = var.gcp_project
  region        = var.db_region
  data          = mongodbatlas_network_peering.test.atlas_gcp_project_id
}

# ---------------------------------------------------------------------------------------------------------------------
# WRITING MONGO IP ACCESS LIST TO GCP
# ---------------------------------------------------------------------------------------------------------------------
module "atlas_ip_access_list" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "atlas_ip_access_list"
  project       = var.gcp_project
  region        = var.db_region
  data          = mongodbatlas_project_ip_access_list.atlas-whitelist.cidr_block
}


# ---------------------------------------------------------------------------------------------------------------------
# WRITING MONGO CIDR FROM GCP TO GCP SM
# ---------------------------------------------------------------------------------------------------------------------
module "atlas_cidr_from_gcp" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "atlas_cidr_from_gcp"
  project       = var.gcp_project
  region        = var.db_region
  data          = mongodbatlas_project_ip_access_list.atlas-whitelist.cidr_block
}