##########################
## MongoAtlas - Main ##
##########################



# ---------------------------------------------------------------------------------------------------------------------
# CREATE MONGODB ATLAS CLUSTER IN THE PROJECT
# ---------------------------------------------------------------------------------------------------------------------

resource "mongodbatlas_advanced_cluster" "atlas-cluster" {
  project_id                    = var.project_id
  name                          = "atlas-cluster"
  cluster_type                  = "REPLICASET"
  replication_specs {
    num_shards = 1
    region_configs {
      region_name     = "CENTRAL_US"
      provider_name   = "TENANT"
      backing_provider_name = "GCP"
      priority        = 6 
      electable_specs {
          instance_size = "M0"
      }
    }
  }
  
}

resource "mongodbatlas_database_user" "test_user" {
  username              = "test-acc-username"
  password              = "abc"
  project_id            = var.project_id
  auth_database_name    = "admin"

  roles {
    role_name     = "readAnyDatabase"
    database_name = "admin"
  }
}
