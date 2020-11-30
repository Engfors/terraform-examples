output "host_vpc" {
  description = "Host VPC Project. All network objects and settings should be there"
  value       = "example-infra-host-vpc"
  // value = google_project.example-infra["example-infra-host-vpc"].project_id
}

output "terraform_project" {
  description = "Terraform Project."
  value       = "example-infra-terraform"
}

output "example-infra_projects" {
  description = "Array of Infrastructure Projects."
  value       = var.example-infra_projects
}
