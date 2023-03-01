variable "atlas_region" {
  description = "The AWS region-name that the cluster will be deployed on"
  type        = string
  default     = "CENTRAL_US"
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
  description = "Cloud service provider on which the servers are provisioned."
  type        = string
  default     = "TENANT"
}

# to remove
variable "project_id" {
  description = "The project id where cluster need to be created"
  type        = string
  default     = "63c2d0e5c539693c6589c960"
}

locals {
  cloud_provider = "GCP"
}

# to remove and replace with HSM post test
variable "atlas_public_key" {
  description = "The project id where cluster need to be created"
  type        = string
  default     = "wcwdwbsg"
}

# to remove and replace with HSM post test
variable "atlas_private_key" {
  description = "The project id where cluster need to be created"
  type        = string
  default     = "9907b31f-7461-4746-bccd-ed07fb6a5bc2"
}

variable "atlas_project_name" {
  description = "The project name "
  type        = string
  default     = "mongo-test"
}

variable "instance_size" {
  description = "Hardware specification for the instance sizes in this region"
  type        = string
  default     = "M0"
}

variable "priority" {
  description = "Election priority of the region."
  type        = number
  default     = 6
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
  default     = "readWrite"
}
