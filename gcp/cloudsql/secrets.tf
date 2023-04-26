
# ---------------------------------------------------------------------------------------------------------------------
# This tf project will write output variables to GCP for Cloudsql
# ---------------------------------------------------------------------------------------------------------------------


# ---------------------------------------------------------------------------------------------------------------------
# WRITING CLOUDSQL SELF LINK TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "cloudsql_self_link" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "cloudsql_self_link"
  project       = var.project
  region        = var.db_region
  data          = google_sql_database_instance.this.self_link
}


# ---------------------------------------------------------------------------------------------------------------------
# WRITING CLOUDSQL SELF LINK TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "cloudsql_connection_name" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "cloudsql_connection_name"
  project       = var.project
  region        = var.db_region
  data          = google_sql_database_instance.this.connection_name
}


# ---------------------------------------------------------------------------------------------------------------------
# WRITING CLOUDSQL INSTANCE TYPE TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "cloudsql_instance_type" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "cloudsql_instance_type"
  project       = var.project
  region        = var.db_region
  data          = google_sql_database_instance.this.instance_type
}


# ---------------------------------------------------------------------------------------------------------------------
# WRITING CLOUDSQL SERVICE ACCOUNT EMAIL ADDRESS TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "cloudsql_service_account_email_address" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "cloudsql_service_account_email_address"
  project       = var.project
  region        = var.db_region
  data          = google_sql_database_instance.this.service_account_email_address
}


# ---------------------------------------------------------------------------------------------------------------------
# WRITING CLOUDSQL IP ADDRESS TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "cloudsql_ip_address" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "cloudsql_ip_address"
  project       = var.project
  region        = var.db_region
  data          = google_sql_database_instance.this.ip_address.0.ip_address
}

# ---------------------------------------------------------------------------------------------------------------------
# WRITING CLOUDSQL DB USER TO GCP 
# ---------------------------------------------------------------------------------------------------------------------
module "postgres_db_username" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "postgres_db_username"
  project       = var.project
  region        = var.db_region
  data          = var.admin
}

# ---------------------------------------------------------------------------------------------------------------------
# WRITE CLOUDSQL USER PWD TO GCP
# ---------------------------------------------------------------------------------------------------------------------
module "postgres_admin_password" {
  source        = "git::git@github.com:harness/terraform-modules.git//gcp/secret-write"
  name          = "postgres_admin_password"
  project       = var.project
  region        = var.db_region
  data          = random_password.admin-pwd.result
}