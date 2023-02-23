
variable "instance_name" {
  description = "The name of the db instance that will be provisioned."
  type        = string
  default     = "my-database-instance"
}


variable "db_name" {
  description = "The name of the db that will be provisioned."
  type        = string
  default     = "my-db"
}


variable "region" {
  description = "The region in which databse instance will be provisioned."
  type        = string
  default     = "us-central1"
}


variable "database_version" {
  description = "The version of database that will be provisioned."
  type        = string
  default     = "POSTGRES_14"
}


variable "database_deletion_policy" {
  description = "The deletion policy for the database. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where databases cannot be deleted from the API if there are users other than cloudsqlsuperuser with access. Possible values are: \"ABANDON\"."
  type        = string
  default     = null
}


variable "project_id" {
  type        = string
  description = "The project ID to manage the Cloud SQL resources"
  default     = "sre-play"
 }


 variable "db_charset" {
  description = "The charset for the default database"
  type        = string
  default     = ""
}


variable "db_collation" {
  description = "The collation for the default database. Example: 'en_US.UTF8'"
  type        = string
  default     = ""
}


variable "user_password" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = "abc"
}


variable "user_name" {
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  type        = string
  default     = "abc"
}


variable "user_deletion_policy" {
  description = "The deletion policy for the user. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where users cannot be deleted from the API if they have been granted SQL roles. Possible values are: \"ABANDON\"."
  type        = string
  default     = null
}

