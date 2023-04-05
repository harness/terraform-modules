variable "project" {
    type = string
    description = "GCP Project"
}

variable "region" {
    type = string
    description = "GCP Region"
}

variable "name" {
    type = string
    description = "Secret to read"
}

variable "enabled" {
    type = bool
    default = true
}