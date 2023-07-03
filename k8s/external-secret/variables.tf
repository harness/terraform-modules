/*
variable "project" {
  type = string
}

variable "region" {
  type = string
}
*/

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
