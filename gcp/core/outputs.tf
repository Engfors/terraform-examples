output "gcp_project" {
  value = var.gcp_project
}

output "gcp_region" {
  value = var.gcp_region
}

output "google_container_cluster" {
  value     = google_container_cluster.cluster
  sensitive = true
}

output "google_sql_database_instance" {
  value     = google_sql_database_instance.instance
  sensitive = true
}

output "sqlproxy_key" {
  value     = google_service_account_key.sqlproxy.private_key
  sensitive = true
}
