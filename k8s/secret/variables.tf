variable "enabled" {
  type    = bool
  default = true
}

variable "name" {
  type = string
}

variable "data" {
  type = map(string)
}

variable "type" {
  type    = string
  default = "Opaque"
}

variable "gke_cluster_name" {
  type = string
}
variable "gcp_project" {
  type = string
}

variable "gcp_region" {
  type = string
}

variable "namespace" {
  type = string
}

variable "cluster_ca_certificate" {
  type = string
}