variable "gcp_region" {}
variable "gcp_zone" {}
variable "gke_machine_type" {}
variable "gke_node_count" {}
variable "cloudsql_tier" {}
variable "gcp_project" {}

variable "sql_databases" {
  type = set(string)
}

variable "primary_ranges" {
  type = list(string)
}

variable "secondary_ranges" {
  type = list(string)
}

variable "cluster_master_ipv4_cidr_block" {
  type = list(string)
}

variable "ip_configuration" {
  description = "The ip_configuration settings subblock"
  type = object({
    authorized_networks = list(map(string))
    ipv4_enabled        = bool
    private_network     = string
    require_ssl         = bool
  })
  default = {
    authorized_networks = []
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = null
  }
}
