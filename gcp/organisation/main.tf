// Folders
# Top-level folders under the organization.
resource "google_folder" "production" {
  display_name = "Production"
  parent       = "organizations/${var.org_id}"
}
resource "google_folder" "non_production" {
  display_name = "Non-Production"
  parent       = "organizations/${var.org_id}"
}

# Folders nested each environment folder.
resource "google_folder" "production_shared" {
  display_name = "Shared"
  parent       = google_folder.production.name
}
resource "google_folder" "non_production_shared" {
  display_name = "Shared"
  parent       = google_folder.non_production.name
}

// Projects
resource "google_project" "terraform" {
  auto_create_network = false
  name                = "${var.organisation}-terraform"
  project_id          = "${var.organisation}-terraform"
  org_id              = var.org_id
  billing_account     = var.billing_account
}

# Folder Production
resource "google_project" "production" {
  for_each            = var.production_projects
  auto_create_network = false
  name                = "${var.organisation}-${each.key}"
  project_id          = "${var.organisation}-${each.key}"
  folder_id           = google_folder.production.name
  billing_account     = var.billing_account
}

# Folder Production/Shared
resource "google_project" "production_shared" {
  for_each            = var.shared_production_projects
  auto_create_network = false
  name                = "${var.organisation}-${each.key}"
  project_id          = "${var.organisation}-${each.key}"
  folder_id           = google_folder.production_shared.name
  billing_account     = var.billing_account
}

# Folder Non-Production
resource "google_project" "non_production" {
  for_each            = var.nonproduction_projects
  auto_create_network = false
  name                = "${var.organisation}-${each.key}"
  project_id          = "${var.organisation}-${each.key}"
  folder_id           = google_folder.non_production.name
  billing_account     = var.billing_account
}

# Folder Non-Production/Shared
resource "google_project" "non_production_shared" {
  for_each            = var.shared_nonproduction_projects
  auto_create_network = false
  name                = "${var.organisation}-${each.key}"
  project_id          = "${var.organisation}-${each.key}"
  folder_id           = google_folder.non_production_shared.name
  billing_account     = var.billing_account
}
