output "redis-ip" {
 description = "Hostname or IP address of the exposed Redis endpoint used by clients to connect to the service."
 value = google_redis_instance.this.host
}

output "redis-port" {
 description = "The port number of the exposed Redis endpoint."
 value = google_redis_instance.this.port
}

output "id" {
 description = "The memorystore instance ID."
 value = google_redis_instance.this.id
}

output "region" {
 description = "The region the instance lives in."
 value = google_redis_instance.this.region
}

output "current_location_id" {
 description = "The current zone where the Redis endpoint is placed."
 value = google_redis_instance.this.location_id
}
