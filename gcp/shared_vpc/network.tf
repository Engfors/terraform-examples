// https://cloud.google.com/vpc/docs/shared-vpc

// Enable shared VPC hosting in the host project.
resource "google_compute_shared_vpc_host_project" "host_project" {
  project = local.host_project

  depends_on = [
    google_project_service.example-infra_projects["example-infra-host-vpc"]
  ]
}

// Enable shared VPC in the projects - explicitly depend on the host
// project enabling it, enabling shared VPC will fail if the host project
// is not yet hosting.
resource "google_compute_shared_vpc_service_project" "example-infra_projects" {
  for_each        = var.example-infra_projects
  host_project    = local.host_project
  service_project = each.key

  depends_on = [
    google_compute_shared_vpc_host_project.host_project,
  ]
}

// Create production vpc
resource "google_compute_network" "example-prod-vpc" {
  name                    = "example-prod-vpc"
  auto_create_subnetworks = "false"
  project                 = google_compute_shared_vpc_host_project.host_project.project


  depends_on = [
    google_compute_shared_vpc_service_project.example-infra_projects,
  ]
}

// Create staging vpc
resource "google_compute_network" "example-staging-vpc" {
  name                    = "example-staging-vpc"
  auto_create_subnetworks = false
  project                 = google_compute_shared_vpc_host_project.host_project.project


  depends_on = [
    google_compute_shared_vpc_service_project.example-infra_projects,
  ]
}

// Create develop vpc
resource "google_compute_network" "example-develop-vpc" {
  name                    = "example-develop-vpc"
  auto_create_subnetworks = false
  project                 = google_compute_shared_vpc_host_project.host_project.project


  depends_on = [
    google_compute_shared_vpc_service_project.example-infra_projects,
  ]
}

// Create production subnetworks
// Public
resource "google_compute_subnetwork" "example-prod-europe-west3-subnet-public" {
  name          = "example-prod-public-range"
  project       = local.host_project
  region        = var.region
  network       = google_compute_network.example-prod-vpc.self_link
  ip_cidr_range = "10.100.50.0/24"
}

// Private
resource "google_compute_subnetwork" "example-prod-europe-west3-subnet-private" {
  name                     = "example-prod-private-range"
  project                  = local.host_project
  region                   = var.region
  network                  = google_compute_network.example-prod-vpc.self_link
  ip_cidr_range            = "10.100.150.0/24"
  private_ip_google_access = true
}

// Create staging subnetworks
// Public
resource "google_compute_subnetwork" "example-staging-europe-west3-subnet-public" {
  name          = "example-staging-public-range"
  project       = local.host_project
  region        = var.region
  network       = google_compute_network.example-staging-vpc.self_link
  ip_cidr_range = "10.101.50.0/24"
}

// Private
resource "google_compute_subnetwork" "example-staging-europe-west3-subnet-private" {
  name                     = "example-staging-private-range"
  project                  = local.host_project
  region                   = var.region
  network                  = google_compute_network.example-staging-vpc.self_link
  ip_cidr_range            = "10.101.150.0/24"
  private_ip_google_access = true
}

// Create develop subnetworks
// Public
resource "google_compute_subnetwork" "example-develop-europe-west3-subnet-public" {
  name          = "example-develop-public-range"
  project       = local.host_project
  region        = var.region
  network       = google_compute_network.example-develop-vpc.self_link
  ip_cidr_range = "10.102.50.0/24"
}

// Private
resource "google_compute_subnetwork" "example-develop-europe-west3-subnet-private" {
  name                     = "example-develop-private-range"
  project                  = local.host_project
  region                   = var.region
  network                  = google_compute_network.example-develop-vpc.self_link
  ip_cidr_range            = "10.102.150.0/24"
  private_ip_google_access = true
}

// https://cloud.google.com/vpc/docs/shared-vpc

// Create  vpc
resource "google_compute_network" "example-vpcs" {
  for_each = local.example-projects

  name                    = "${each.key}-vpc"
  auto_create_subnetworks = false
  project                 = google_compute_shared_vpc_host_project.host_project.project


  depends_on = [
    google_compute_shared_vpc_service_project.example-projects,
  ]
}

// Create subnetworks
// Public
resource "google_compute_subnetwork" "example-public-subnets" {
  for_each      = local.example-projects
  name          = "${each.key}-public-range"
  project       = local.host_project
  region        = var.region
  network       = google_compute_network.example-vpcs[each.key].self_link
  ip_cidr_range = var.example-subnet-public-ip-ranges[each.key]
}

// Private // removed //

resource "google_compute_address" "example-external-ips" {
  for_each     = local.example-projects
  project      = each.key
  name         = "${each.key}-external-ip"
  region       = var.region
  address_type = "EXTERNAL"
}



resource "google_compute_global_address" "example-service-peering-addresses" {
  for_each = local.example-projects

  project       = local.host_project
  name          = "${each.key}-service-peering-address"
  purpose       = "VPC_PEERING"
  address       = var.example-service-peering-ip-ranges[each.key]
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.example-vpcs[each.key].id
}

resource "google_service_networking_connection" "example-service-peerings" {
  for_each = local.example-projects

  network                 = google_compute_network.example-vpcs[each.key].id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.example-service-peering-addresses[each.key].name]
  depends_on = [
    google_project_service.example-infra-terraform_servicenetworking
  ]
}

