# ---------------------------------------------------------------------------------------------------------------------
# This tf project will create a mongo cluster, 
#a db user, 
# a vpc peering between supplied GCP project and the mongo cluster
# ---------------------------------------------------------------------------------------------------------------------


provider "google" {
  project     = var.gcp_project
  region      = var.db_region
}

# data "mongodbatlas_roles_org_id" "test" {
# }

# ---------------------------------------------------------------------------------------------------------------------
# CREATE MONGODB PROJECT
# ---------------------------------------------------------------------------------------------------------------------
# user needs group creator role
# resource "mongodbatlas_project" "atlas-project" {
#   #org_id = var.atlas_org_id
#   org_id      = data.mongodbatlas_roles_org_id.test.org_id
#   name        = var.atlas_project_name
# }

# ---------------------------------------------------------------------------------------------------------------------
# CREATE MONGODB DATABASE CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

  resource "mongodbatlas_advanced_cluster" "atlas-cluster" {
  project_id                      = var.atlas_project_id
  name                            = "${var.atlas_project_name}-cluster"
  mongo_db_major_version          = var.mongodb_major_ver
  cluster_type                    = var.cluster_type
  disk_size_gb                    = var.disk_size_gb
  replication_specs {
    #num_shards = var.num_shards
    region_configs {
      region_name           = var.atlas_region
      provider_name         = local.cloud_provider
      priority              = var.priority
      electable_specs {
          instance_size     = var.instance_size
          node_count        = 3
      }
    }
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE MONGODB DATABASE USER
# ---------------------------------------------------------------------------------------------------------------------

resource "mongodbatlas_database_user" "db_user" {
  username           = var.mongo-username
  password           = random_password.mongo-user-pwd.result
  project_id         = var.atlas_project_id
  auth_database_name = var.mongo-auth-db-name

  roles {
    role_name       = var.role-name
    database_name   = "${var.atlas_project_name}-db"
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE MONGODB DATABASE USER PASSWORD
# ---------------------------------------------------------------------------------------------------------------------
resource "random_password" "mongo-user-pwd" {
  length            = 16
  special           = true
  override_special  = "_%@"
}

# ---------------------------------------------------------------------------------------------------------------------
# WRITE USER PWD TO GCP
# ---------------------------------------------------------------------------------------------------------------------
module "mongo_user_password" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "mongo-user-pwd"
  project       = var.gcp_project
  region        = var.db_region
  data          = random_password.mongo-user-pwd.result
}

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
# READ PUBLIC KEY FROM GCP
# ---------------------------------------------------------------------------------------------------------------------
module "atlas_read_public_key" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-read"
  name          = "atlas_public_key"
  project       = var.gcp_project
  region        = var.db_region
}

# ---------------------------------------------------------------------------------------------------------------------
# READ PUBLIC KEY FROM GCP
# ---------------------------------------------------------------------------------------------------------------------
module "atlas_read_private_key" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-read"
  name          = "atlas_private_key"
  project       = var.gcp_project
  region        = var.db_region
}

# Provider
provider "mongodbatlas" {
  public_key        = module.atlas_read_public_key.data
  private_key       = module.atlas_read_private_key.data
  # public_key        = var.atlas_public_key
  # private_key       = var.atlas_private_key
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE PEERING CONNECTION REQUEST
# ---------------------------------------------------------------------------------------------------------------------
resource "mongodbatlas_network_peering" "test" {
  project_id          = var.atlas_project_id
  container_id        = mongodbatlas_advanced_cluster.atlas-cluster.replication_specs[0].container_id["${local.cloud_provider}:${var.atlas_region}"]
  provider_name       = local.cloud_provider
  gcp_project_id      = var.gcp_project
  network_name        = var.mongodbatlas_network_peering_network_name
}

# ---------------------------------------------------------------------------------------------------------------------
# GCP PROVIDER IS CONFIGURED
# ---------------------------------------------------------------------------------------------------------------------
data "google_compute_network" "default" {
  project     = var.gcp_project
  name        = var.google_compute_network_name
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE GCP PEERING
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_network_peering" "peering" {
  name            = var.google_compute_network_peering_name
  network         = data.google_compute_network.default.self_link
  peer_network    = "https://www.googleapis.com/compute/v1/projects/${mongodbatlas_network_peering.test.atlas_gcp_project_id}/global/networks/${mongodbatlas_network_peering.test.atlas_vpc_name}"
}


data "google_compute_subnetwork" "sub-network" {
  name        = var.google_compute_subnetwork
  region      = var.db_region
}

# ---------------------------------------------------------------------------------------------------------------------
# GRANTING IP ACCESS TO MONGODB ATLAS PROJECT
# ---------------------------------------------------------------------------------------------------------------------
resource "mongodbatlas_project_ip_access_list" "atlas-whitelist" {
  project_id        = var.atlas_project_id
  cidr_block        = data.google_compute_subnetwork.sub-network.ip_cidr_range
  comment           = "This is for GCP"
}

