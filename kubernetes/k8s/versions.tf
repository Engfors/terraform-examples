terraform {
  required_version = "~> 0.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.51"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

provider "google" {
  project = local.gcp_project
  region  = local.gcp_region
}

# Retrieve an access token as the Terraform runner
data "google_client_config" "token" {}

data "google_container_cluster" "cluster_data" {
  name     = local.google_container_cluster.name
  location = local.google_container_cluster.location
  project  = local.google_container_cluster.project
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.cluster_data.endpoint}"
  token = data.google_client_config.token.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.cluster_data.master_auth[0].cluster_ca_certificate,
  )
}

data "terraform_remote_state" "core" {
  backend = "remote"
  config = {
    organization = ""
    workspaces = {
      name = "${var.core_workspace}"
    }
  }
}
