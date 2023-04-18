variable "project" {
  type        = string
  description = "GCP Project"
}

variable "region" {
  type        = string
  description = "GCP Region"
}

variable "enabled" {
  type    = bool
  default = true
}