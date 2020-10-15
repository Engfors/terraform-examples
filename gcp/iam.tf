// Creates the service account
resource "google_service_account" "sa" {
  account_id   = "sa_name"
  display_name = "sa_name"
  project      = var.google_project
}

// Creates the service account key
resource "google_service_account_key" "sa_key" {
  service_account_id = google_service_account.sa.name
}
