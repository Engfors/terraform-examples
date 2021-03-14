terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.48.0"
    }
  }
}

provider "google" {
  // Configuration options
  // Use env var for credentials (export GOOGLE_CREDENTIALS=$(cat <file_name>.json | jq -c))
  project = var.google_project
  region  = var.google_region
}
