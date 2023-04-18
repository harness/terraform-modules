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

variable "enabled" {
  type    = bool
  default = true
}