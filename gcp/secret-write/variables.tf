variable "project" {
  type        = string
  description = "GCP Project"
}

variable "region" {
  type        = string
  description = "GCP Region"
}


variable "data" {
  type        = string
  description = "Secret Data"
  sensitive   = true
}

variable "replication_policy" {
  type        = string
  description = "Replication policy for the secret. Options: 'automatic' or 'user_managed'"
  default     = "user_managed"

  validation {
    condition     = contains(["automatic", "user_managed"], var.replication_policy)
    error_message = "replication_policy must be either 'automatic' or 'user_managed'."
  }
}

variable "replica_locations" {
  type        = list(string)
  description = "List of replica locations for user_managed replication. Ignored if replication_policy is 'automatic'"
  default     = ["us-central1", "us-east1"]
}