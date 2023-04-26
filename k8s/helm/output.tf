## helm_release

output "metadata" {
  description = "Block status of the deployed release."
  value       = one(helm_release.this[*].metadata)
}