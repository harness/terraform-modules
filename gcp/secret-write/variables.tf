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
    description = "Name of Secret to create"
}

variable "data" {
    type = string 
    description = "Secret Data"
}

variable "labels" {
    type = map(string) 
    default = {}
}

variable "enabled" {
    type = bool
    default = true
}