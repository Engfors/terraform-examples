// Folders
# Top-level folders under the organization.
resource "google_folder" "root_folders" {
  for_each     = var.root_folders
  display_name = each.key
  parent       = "organizations/${var.org_id}"
}

// Projects
# Folder example-infra
resource "google_project" "example-infra" {
  for_each            = var.example-infra_projects
  auto_create_network = false
  name                = each.key
  project_id          = each.key
  folder_id           = google_folder.root_folders["example-infra"].name
  billing_account     = var.billing_account
}
