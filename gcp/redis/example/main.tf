resource "google_redis_instance" "redis_instance" {
  name = var.name
  display_name = var.display_name
  memory_size_gb = var.memory_size_gb
  tier = var.tier
  region = var.region
  location_id = var.location_id
  alternative_location_id = var.alternative_location_id
  authorized_network = var.authorized_network
  labels = var.labels
  redis_version = var.redis_version
}


