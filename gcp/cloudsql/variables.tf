variable "project" {
  type = string
}

variable "admin" {
  type = string
  default = "admin"
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

# variable "name" {
#   type        = string
#   description = "Name of the Kubernetes secret that will be created"
# }

# variable "registries" {
#   type = map(object({
#     username = string
#     password = string
#   }))

#   description = "Map of registry hostnames to credentials (username, password)."
# }