output "redis-primary-ip" {
  value = google_redis_instance.redis_instance.host
}

output "redis-primary-port" {
  value = google_redis_instance.redis_instance.port
}

output "id" {
  description = "The memorystore instance ID."
  value       = google_redis_instance.redis_instance.id
}

output "region" {
  description = "The region the instance lives in."
  value       = google_redis_instance.redis_instance.region
}

output "current_location_id" {
  description = "The current zone where the Redis endpoint is placed."
  value       = google_redis_instance.redis_instance.location_id
}