# ---------------------------------------------------------------------------------------------------------------------
# This tf project will write output variables to GCP for Redis
# ---------------------------------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------------------------------
# WRITING REDIS INSTANCE IP TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "redis_ip" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "redis_ip"
  project       = var.project
  region        = var.redis_region
  data          = google_redis_instance.this.host
}


# ---------------------------------------------------------------------------------------------------------------------
# WRITING REDIS INSTANCE PORT TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "redis_port" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "redis_port"
  project       = var.project
  region        = var.redis_region
  data          = google_redis_instance.this.port
}


# ---------------------------------------------------------------------------------------------------------------------
# WRITING REDIS INSTANCE ID TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "redis_instance_id" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "redis_instance_id"
  project       = var.project
  region        = var.redis_region
  data          = google_redis_instance.this.id
} 


# ---------------------------------------------------------------------------------------------------------------------
# WRITING REDIS INSTANCE REGION TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "redis_instance_region" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "redis_instance_region"
  project       = var.project
  region        = var.redis_region
  data          = google_redis_instance.this.region
} 


# ---------------------------------------------------------------------------------------------------------------------
# WRITING CLOUDSQL SELF LINK TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "redis_current_location_id" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "redis_current_location_id"
  project       = var.project
  region        = var.redis_region
  data          = google_redis_instance.this.location_id
} 
