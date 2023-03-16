variable "cluster_endpoint" {
    type = string
}

variable "client_certificate" {
    type = string
}

variable "client_key" {
    type = string
}

variable "cluster_ca_certificate" {
    type = string
}

variable "name" {
    type = string
}

variable "data" {
    type = map(string)
}

variable "type" {
    type = string
    default = "Opaque"
}