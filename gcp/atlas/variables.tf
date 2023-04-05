variable "gcp_project" {
  type = string
  default = "us-east1"
}

variable "db_region" {
  type = string
  default = "us-west1"
}

variable "atlas_region" {
  description = "The GCP region-name that the cluster will be deployed on"
  type        = string
  default     = "CENTRAL_US"
}
variable "instance_type" {
  description = "The Atlas instance-type name"
  type        = string
  default     = ""
}

variable "mongodb_major_ver" {
  description = "The MongoDB cluster major version"
  type        = number
  default     = "4.4"
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
  default     = 16
}

variable "auto_scaling_disk_gb_enabled" {
  description = "Indicating if disk auto-scaling is enabled"
  type        = bool
  default     = true
}


variable "provider_name" {
  description = "Cloud service provider on which the servers are provisioned."
  type        = string
  default     = "GCP"
}


variable "atlas_project_id" {
  description = "The project id where atlas cluster need to be created"
  type        = string
  default     = "64011967723eb94df1cf4033"
}

locals {
  cloud_provider = "GCP"
  gcp_project = "sre-play"
}

# variable "atlas_public_key" {
#   description = "The project id where cluster need to be created"
#   type        = string
#   default     = <>
# }

# variable "atlas_private_key" {
#   description = "The project id where cluster need to be created"
#   type        = string
#   default     = <>
# }

variable "atlas_project_name" {
  description = "The project name "
  type        = string
  default     = "sre-play"
}

variable "instance_size" {
  description = "Hardware specification for the instance sizes in this region"
  type        = string
  default     = "M30"
}

variable "priority" {
  description = "Election priority of the region."
  type        = number
  default     = 7
}

variable "mongo-username" {
  description = "Username for authenticating to MongoDB"
  type        = string
  default     = "mongo-user"
}

variable "mongo-user-pwd" {
  description = "User's initial password"
  type        = string
  default     = "mongo-pwd"
}

variable "mongo-auth-db-name" {
  description = "Database against which Atlas authenticates the user"
  type        = string
  default     = "admin"
}

variable "role-name" {
  description = "Database against which Atlas authenticates the user"
  type        = string
  default     = "atlasAdmin"
}

variable "google_compute_network_name" {
  type        = string
  default     = "default"
}

variable "google_compute_subnetwork" {
  type        = string
  default     = "default"
}

variable "mongodbatlas_network_peering_network_name" {
  type        = string
  default     = "default"
}

variable "google_compute_network_peering_name" {
  type        = string
  default     = "peering-gcp-terraform-test"
}
