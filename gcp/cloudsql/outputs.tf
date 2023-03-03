output "self_link" {
  description = "The URI of the created db instance resource."
  value = google_sql_database_instance.this.self_link
}

output "connection_name" {
  description = "The connection name of the instance to be used in connection strings."
  value = google_sql_database_instance.this.connection_name
}

output "service_account_email_address" {
  description = "The service account email address assigned to the instance."
  value = google_sql_database_instance.this.service_account_email_address
}

output "ip_address" {
  description = "The IPv4 address assigned."
  value = google_sql_database_instance.this.ip_address.0.ip_address
}

 output "instance_type" {
   description = "The type of the instance."
   value = google_sql_database_instance.this.instance_type
 }
