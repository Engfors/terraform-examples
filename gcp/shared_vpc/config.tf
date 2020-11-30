terraform {
  backend "remote" {
    organization = "example"

    workspaces {
      name = "example-shared_vpc"
    }
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.45.0"
    }
  }
}

data "terraform_remote_state" "organisation" {
  backend = "remote"
  config = {
    organization = "example"
    workspaces = {
      name = "example-organisation"
    }
  }
}

provider "google" {
  # Configuration options
  region = "europe-west3"
}
