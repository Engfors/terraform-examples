// Compute service needs to be enabled for all projects, these resource verifies that they're enabled.
resource "google_project_service" "example-infra_projects" {
  for_each           = local.example-infra_projects
  project            = each.key
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

// Service Networking API for vpc_host must enabled
resource "google_project_service" "example-host_vpc_servicenetworking" {
  project            = local.host_project
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "example-infra-terraform_servicenetworking" {
  project            = local.terraform_project
  service            = "servicenetworking.googleapis.com"
  disable_on_destroy = false
}
