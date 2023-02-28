variable "project" {
  type = string
}

variable "redis_name" {
  type = string
  default = "redis-test"
}

variable "redis_display_name" {
  type = string
  default = "redis-display-name"
}

variable "redis_memory_size_gb" {
  type = number
  default = 1
}

variable "redis_tier" {
  type = string
  default = "STANDARD_HA"
}

variable "redis_region" {
  type = string
  default = "us-west1"
}

variable "redis_location_id" {
  type = string
  default = "us-west1-a"
}

variable "redis_alternative_location_id" {
  type = string
  default = "us-west1-c"
}

variable "redis_version" {
  type = string
  default = "REDIS_5_0"
}
