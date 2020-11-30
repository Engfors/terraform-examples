terraform {
  backend "remote" {
    organization = "Example"

    workspaces {
      name = "example-organisation"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.45.0"
    }
  }
}

provider "google" {
  # Configuration options
  region = "europe-west3"
}
