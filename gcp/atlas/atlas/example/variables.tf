variable "region" {
  description = "The AWS region-name that the cluster will be deployed on"
  type        = string
  default     = "US_EAST_1"
}

variable "cluster_name" {
  description = "The cluster name"
  type        = string
  default     = "test-cluster"
}

variable "instance_type" {
  description = "The Atlas instance-type name"
  type        = string
  default     = ""
}

variable "mongodb_major_ver" {
  description = "The MongoDB cluster major version"
  type        = number
  default     = "4.2"
}

variable "cluster_type" {
  description = "The MongoDB Atlas cluster type - SHARDED/REPLICASET/GEOSHARDED"
  type        = string
  default     = "REPLICASET"
}

variable "num_shards" {
  description = "number of shards"
  type        = number
  default     = "1"
}

variable "replication_factor" {
  description = "The Number of replica set members, possible values are 3/5/7"
  type        = number
  default     = null
}

variable "provider_backup" {
  description = "Indicating if the cluster uses Cloud Backup for backups"
  type        = bool
  default     = true
}

variable "disk_size_gb" {
  description = "Capacity,in gigabytes,of the host’s root volume"
  type        = number
  default     = null
}

variable "auto_scaling_disk_gb_enabled" {
  description = "Indicating if disk auto-scaling is enabled"
  type        = bool
  default     = true
}


variable "provider_name" {
  description = "Indicating if the cluster uses Cloud Backup for backups"
  type        = string
  default     = "GCP"
}


variable "project_id" {
  description = "The project id where cluster need to be created"
  type        = string
  default     = "63c2d0e5c539693c6589c960"
}

locals {
  cloud_provider = "GCP"
}