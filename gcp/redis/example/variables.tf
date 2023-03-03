variable "name" {
  default = "redis-test"
}

variable "memory_size_gb" {
  default = 1
}

variable "tier" {
  default = "STANDARD_HA"
}

variable "region" {
  default = "us-west1"
}

variable "location_id" {
  default = "us-west1-a"
}

variable "alternative_location_id" {
  default = "us-west1-c"
}

variable "authorized_network" {
  default = "default"
}

variable "labels" {
  default = {cluster = "testing_labels_redis" }
}

variable "redis_version" {
  default = "REDIS_5_0"
}

variable "display_name" {
  default = "Redis Test"
}
