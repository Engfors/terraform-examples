variable "google_project" {
  type        = string
  description = "Sets the GCP project used by this workspace"
}

variable "google_region" {}

variable "google_zone" {}

variable "node_version" {}

variable "composer_network" {
  type        = string
  description = "Network used by composer"
}

variable "composer_environment_name" {
  type        = string
  description = "The name of the environment you want to create"
}

variable "composer_subnetwork" {}

variable "gke_name" {}

variable "service_account" {}

variable "composer_machine_type" {
  type        = string
  description = "Machine type used by composer workers"
}

variable "scheduler_machine_type" {
  type        = string
  description = "Machine type used by composer scheduler"
}
