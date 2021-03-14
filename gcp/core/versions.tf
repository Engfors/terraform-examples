terraform {
  required_version = "~> 0.14"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.51"
    }
  }
}

provider "google" {
  project = var.gcp_project
  region  = var.gcp_region
}
