variable "project" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_region" {
  type = string
  default = "us-west1"
}

variable "db_tier" {
  type = string
  default = "db-f1-micro"
}

variable "db_version" {
  type = string 
  default = "POSTGRES_14"
}

variable "db_protection" {
  type = string
  default = "false"
}

variable "db_user_labels" {
  type = map(string)
  default = null
}

variable "db_activation_policy" {
  type = string
  default = ""
}

variable "databases" {
  type = list(string)
  default = []
}