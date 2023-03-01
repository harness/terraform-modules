
# ---------------------------------------------------------------------------------------------------------------------
# CREATE MONGODB PROJECT
# ---------------------------------------------------------------------------------------------------------------------

# resource "mongodbatlas_project" "atlas-project" {
#   org_id = var.atlas_org_id
#   name = var.atlas_project_name
# }

# ---------------------------------------------------------------------------------------------------------------------
# CREATE MONGODB DATABASE USER
# ---------------------------------------------------------------------------------------------------------------------

resource "mongodbatlas_database_user" "db_user" {
  username           = var.mongo-username
  password           = var.mongo-user-pwd
  project_id         = var.project_id
  auth_database_name = var.mongo-auth-db-name #"admin"

  roles {
    role_name     = var.role-name
    database_name = "${var.atlas_project_name}-db"
  }
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE MONGODB DATABASE CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

  resource "mongodbatlas_advanced_cluster" "atlas-cluster" {
  project_id                      = var.project_id
  name                            = "${var.atlas_project_name}-cluster"
  #provider_instance_size_name    = var.cluster_instance_size_name
  #mongo_db_major_version         = var.mongodb_major_ver
  cluster_type                    = var.cluster_type
  replication_specs {
    num_shards = var.num_shards
    region_configs {
      region_name           = var.atlas_region
      provider_name         = var.provider_name
      # provider_name                = cloud_provider
      backing_provider_name = local.cloud_provider
      priority              = var.priority
      electable_specs {
          instance_size     = var.instance_size
      }
    }
  }
}


# resource "mongodbatlas_project_ip_access_list" "ip" {
#   project_id        = var.project_id
#   ip_address        = var.ip_address
# }


# Provider
provider "mongodbatlas" {
  public_key        = var.atlas_public_key
  private_key       = var.atlas_private_key
}
