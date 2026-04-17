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
}

variable "replication_regions" {
  type        = list(string)
  description = "GCP regions for Secret Manager replication. Defaults to us-central1 and us-east1."
  default     = ["us-central1", "us-east1"]
}