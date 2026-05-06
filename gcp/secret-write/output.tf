# Label Module Outputs
output "id" {
  description = "ID of the secret"
  value       = module.this.id
}

output "namespace" {
  description = "Normalized namespace"
  value       = module.this.namespace
}

output "stage" {
  description = "Normalized stage"
  value       = module.this.stage
}

output "tags" {
  description = "Normalized tag map"
  value       = module.this.tags
}

# Secret-specific outputs
output "secret_id" {
  description = "The ID of the secret in Google Secret Manager"
  value       = try(google_secret_manager_secret.this[0].secret_id, null)
}

output "secret_name" {
  description = "The full name of the secret in Google Secret Manager"
  value       = try(google_secret_manager_secret.this[0].name, null)
}

output "secret_version_id" {
  description = "The ID of the secret version"
  value       = try(google_secret_manager_secret_version.this[0].id, null)
}

output "secret_version_name" {
  description = "The full name of the secret version"
  value       = try(google_secret_manager_secret_version.this[0].name, null)
}

output "create_time" {
  description = "The time at which the secret was created"
  value       = try(google_secret_manager_secret.this[0].create_time, null)
}

output "enabled" {
  description = "Whether the module is enabled"
  value       = module.this.enabled
}

output "replication_policy" {
  description = "The replication policy used for the secret"
  value       = var.replication_policy
}

output "replica_locations" {
  description = "The replica locations used for user_managed replication"
  value       = var.replication_policy == "user_managed" ? var.replica_locations : null
}