variable "domain" {}
variable "org_id" {}
variable "billing_account" {}
variable "organisation" {}

variable "production_projects" {
  type = set(string)
}
variable "shared_production_projects" {
  type = set(string)
}
variable "nonproduction_projects" {
  type = set(string)
}
variable "shared_nonproduction_projects" {
  type = set(string)
}
