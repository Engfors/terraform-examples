locals {
  gcp_project                  = data.terraform_remote_state.core.outputs.gcp_project
  gcp_region                   = data.terraform_remote_state.core.outputs.gcp_region
  google_container_cluster     = data.terraform_remote_state.core.outputs.google_container_cluster
  google_sql_database_instance = data.terraform_remote_state.core.outputs.google_sql_database_instance
  sqlproxy_key                 = data.terraform_remote_state.core.outputs.sqlproxy_key
}

variable "gke_namespaces" {
  type    = set(string)
  default = []
}

variable "core_workspace" {}

variable "http_ingress" {
  type        = set(string)
  description = "List of deployment(s) using http ingress (no domain, no cert)"
  default     = []
}

variable "https_ingress" {
  type        = map(any)
  description = "List of deployment(s) using https ingress (domain + cert)"
  default     = {}
}
