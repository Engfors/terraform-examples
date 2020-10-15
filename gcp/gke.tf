// Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

// Save cluster data for use with Kubernetes provider
data "google_container_cluster" "my_cluster" {
  name     = google_container_cluster.primary.name
  location = var.zone
  project  = var.google_project
}

// Create GKE
resource "google_container_cluster" "primary" {
  name       = "${var.google_project}-cluster"
  location   = var.zone
  network    = module.vpc.network_name
  subnetwork = module.vpc.subnets_names[0]

  # release_channel {
  #   channel = "REGULAR"
  # }

  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}

// Create node pool
resource "google_container_node_pool" "primary_nodes" {
  name           = "prod-pool"
  cluster        = google_container_cluster.primary.name
  node_count     = 1
  node_locations = var.GKE_zones

  node_config {
    preemptible  = false
    machine_type = var.GKE_machine_type
    disk_size_gb = "10"

    metadata = {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }

// Create GKE namespace
resource "kubernetes_namespace" "prod" {
  metadata {
    name = "prod"
  }
}