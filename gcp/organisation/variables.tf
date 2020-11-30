variable "organisation" {
  description = "Organisation Name"
  type        = string
  default     = "example"
}

variable "domain" {
  description = "Organisation Domain"
  type        = string
  default     = "example.com"
}

variable "org_id" {
  description = "Organisation Google ID"
  type        = string
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
}

variable "root_folders" {
  description = "Root Folders for the Organisation"
  type        = set(string)
  default     = ["example-infra", "unsorted"]
}

variable "example-infra_projects" {
  description = "Projects inside `example-infra` folder"
  type        = set(string)
  default     = ["example-infra-terraform", "example-infra-operations", "example-infra-monitoring", "example-infra-host-vpc"]
}
