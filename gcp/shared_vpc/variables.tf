locals {
  host_project           = data.terraform_remote_state.organisation.outputs.host_vpc
  terraform_project      = data.terraform_remote_state.organisation.outputs.terraform_project
  example-infra_projects = data.terraform_remote_state.organisation.outputs.example-infra_projects
}

variable "region" {
  type        = string
  description = "Default europe-west3 = Frankfurt"
  default     = "europe-west3"
}

variable "example-infra_projects" {
  type = set(string)
}

variable "example-subnet-public-ip-ranges" {
  default = {
    "example-prod"  = "10.105.50.0/24",
    "example-stage" = "10.205.50.0/24",
  }
}

variable "example-service-peering-ip-ranges" {
  default = {
    "example-prod"  = "10.105.55.0",
    "example-stage" = "10.205.55.0",
  }
}

