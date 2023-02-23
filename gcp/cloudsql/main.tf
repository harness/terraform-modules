provider "google" {
  project     = var.project
  region      = var.db_region
}


# ---------------------------------------------------------------------------------------------------------------------
# CREATE CLOUDSQL DATABASE INSTANCE IN GCP
# ---------------------------------------------------------------------------------------------------------------------
resource "google_sql_database_instance" "this" {
  name                  = var.db_name
  region                = var.db_region

  settings {
    tier                  = var.db_tier
    user_labels           = var.db_user_labels
    activation_policy     = var.db_activation_policy
  }
 
  database_version      = var.db_version
  deletion_protection   = var.db_protection
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE SQL DATABASE
# ---------------------------------------------------------------------------------------------------------------------

resource "google_sql_database" "this" {
  for_each        = toset(var.databases)
  name            = each.key
  instance        = google_sql_database_instance.this.name
}

/*
# ---------------------------------------------------------------------------------------------------------------------
# CREATE SQL USER
# ---------------------------------------------------------------------------------------------------------------------

resource "google_sql_user" "this" {
  for_each        = var.google_sql_user
  name            = each.value.name
  project         = var.project_id
  instance        = google_sql_database_instance.this.name
  password        = var.user_password
  depends_on = [
    google_sql_database_instance.this
  ]
  deletion_policy = var.db_protection
}
*/