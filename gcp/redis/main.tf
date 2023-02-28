provider "google" {
  project       = var.project
  region        = var.redis_region
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE Google REDIS INSTANCE IN GCP
# ---------------------------------------------------------------------------------------------------------------------
resource "google_redis_instance" "this" {
  name                      = var.redis_name
  display_name              = var.redis_display_name
  memory_size_gb            = var.redis_memory_size_gb
  tier                      = var.redis_tier
  region                    = var.redis_region
  location_id               = var.redis_location_id
  alternative_location_id   = var.redis_alternative_location_id
  replica_count             = var.redis_replica_count
  redis_version             = var.redis_version
}
