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

# ---------------------------------------------------------------------------------------------------------------------
# CREATE MONGODB DATABASE USER PASSWORD
# ---------------------------------------------------------------------------------------------------------------------
resource "random_password" "admin-pwd" {
  length            = 16
  special           = true
  override_special  = "_%@"
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE SQL USER
# ---------------------------------------------------------------------------------------------------------------------

resource "google_sql_user" "this" {
  name            = var.admin
  project         = var.project
  instance        = google_sql_database_instance.this.name
  password        = random_password.admin-pwd.result
  depends_on = [
    google_sql_database_instance.this
  ]
  # deletion_policy = var.db_protection
}
