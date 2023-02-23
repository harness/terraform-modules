##########################
## Cloudsql - Main ##
##########################


# ---------------------------------------------------------------------------------------------------------------------
# CREATE CLOUDSQL DATABASE INSTANCE IN GCP
# ---------------------------------------------------------------------------------------------------------------------

resource "google_sql_database_instance" "postgres-from-terraform" {
  name             = var.instance_name
  region           = var.region
  database_version = var.database_version
  settings {
    tier = "db-f1-micro"
  }

  deletion_protection  = "false"
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE SQL DATABASE
# ---------------------------------------------------------------------------------------------------------------------

resource "google_sql_database" "sql_database" {
  name            = var.db_name
  project         = var.project_id
  instance        = google_sql_database_instance.postgres-from-terraform.name
  charset         = var.db_charset
  collation       = var.db_collation
  depends_on      = [google_sql_database_instance.postgres-from-terraform]
  deletion_policy = var.database_deletion_policy
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE SQL USER
# ---------------------------------------------------------------------------------------------------------------------

resource "google_sql_user" "sql_user" {
  name            = var.user_name
  project         = var.project_id
  instance        = google_sql_database_instance.postgres-from-terraform.name
  password        = var.user_password
  depends_on = [
    google_sql_database_instance.postgres-from-terraform
  ]
  deletion_policy = var.user_deletion_policy
}
