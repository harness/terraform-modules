# Label Module Outputs
output "id" {
  description = "ID of the secret"
  value       = module.this.id
}

output "name" {
  description = "Normalized name of the secret"
  value       = module.this.name
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
output "secret_name" {
  description = "Name/ID of the secret in Google Secret Manager"
  value       = try(data.google_secret_manager_secret_version.this[0].secret, null)
}

output "version" {
  description = "Version of the secret that was retrieved"
  value       = try(data.google_secret_manager_secret_version.this[0].version, null)
}

output "create_time" {
  description = "The time at which the secret version was created"
  value       = try(data.google_secret_manager_secret_version.this[0].create_time, null)
}

output "enabled" {
  description = "Whether the module is enabled"
  value       = module.this.enabled
}