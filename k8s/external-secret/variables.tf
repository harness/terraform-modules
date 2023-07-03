/*
variable "project" {
  type = string
}

variable "region" {
  type = string
}
*/

variable "enabled" {
  type = bool
  default = true
}

variable "secretName" {
  type = string
}

variable "secretNamespace" {
  type = string
}

variable "clusterSecretStore" {
  type = string
}

variable "secretType" {
  type = string
}

variable "secretTemplate" {
  type = map(string)
}

variable "secretDataRef" {
  type = map(string)
}
