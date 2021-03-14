locals {
  ip_configuration_enabled = length(keys(var.ip_configuration)) > 0 ? true : false
  ip_configurations = {
    enabled  = var.ip_configuration
    disabled = {}
  }
}

##############################################
#              REQUIRED APIS                 #
##############################################

module "required_apis" {
  source = "./modules/enable_api"
  active_api = [
    "cloudresourcemanager.googleapis.com",
    "sqladmin.googleapis.com",
    "sourcerepo.googleapis.com",
    "cloudbuild.googleapis.com",
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com"
  ]
}

##############################################
#                VPC NETWORK                 #
##############################################
resource "google_compute_network" "vpc_network" {
  name                    = "example-network"
  auto_create_subnetworks = false

  description = "The network for the example"
}

resource "google_compute_subnetwork" "eu_west1" {
  name                     = "example-network-k8s-cluster-1"
  ip_cidr_range            = var.primary_ranges[0]
  region                   = "europe-west1"
  network                  = google_compute_network.vpc_network.self_link
  private_ip_google_access = "true"
}
##############################################
#                GKE CLUSTER                 #
##############################################

resource "google_container_cluster" "cluster" {
  name               = "example-cluster"
  location           = var.gcp_zone
  network            = google_compute_network.vpc_network.name
  subnetwork         = google_compute_subnetwork.eu_west1.self_link
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"

  initial_node_count       = 1
  remove_default_node_pool = true

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.secondary_ranges[0]
    services_ipv4_cidr_block = var.secondary_ranges[1]
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.cluster_master_ipv4_cidr_block[0]
  }

  release_channel {
    channel = "REGULAR"
  }

  depends_on = [
    module.required_apis
  ]
}

resource "google_container_node_pool" "node_pool" {
  name       = "main-pool"
  location   = var.gcp_zone
  cluster    = google_container_cluster.cluster.name
  node_count = var.gke_node_count


  node_config {
    preemptible  = false
    machine_type = var.gke_machine_type
    image_type   = "COS_CONTAINERD"

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/trace.append"
    ]
  }
  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

##############################################
#                 CLOUD NAT                  #
##############################################
resource "google_compute_router" "router" {
  name    = "nat-router"
  network = google_compute_network.vpc_network.name
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat-config"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

##############################################
#                CLOUD SQL                   #
##############################################

resource "google_sql_database_instance" "instance" {
  name             = "example-instance"
  database_version = "MYSQL_8_0"
  region           = var.gcp_region

  settings {
    tier = var.cloudsql_tier

    backup_configuration {
      binary_log_enabled = true
      enabled            = true
      location           = "eu"
      start_time         = "22:00"
    }

    dynamic "ip_configuration" {
      for_each = [local.ip_configurations[local.ip_configuration_enabled ? "enabled" : "disabled"]]
      content {
        ipv4_enabled    = lookup(ip_configuration.value, "ipv4_enabled", null)
        private_network = lookup(ip_configuration.value, "private_network", null)
        require_ssl     = lookup(ip_configuration.value, "require_ssl", null)

        dynamic "authorized_networks" {
          for_each = lookup(ip_configuration.value, "authorized_networks", [])
          content {
            expiration_time = lookup(authorized_networks.value, "expiration_time", null)
            name            = lookup(authorized_networks.value, "name", null)
            value           = lookup(authorized_networks.value, "value", null)
          }
        }
      }
    }
  }

  deletion_protection = "true"

  depends_on = [
    module.required_apis
  ]
}

resource "google_sql_database" "databases" {
  for_each  = var.sql_databases
  name      = each.key
  instance  = google_sql_database_instance.instance.name
  collation = "utf8mb4_unicode_ci"
  charset   = "utf8mb4"
}

##############################################
#               SQLPROXY SA                  #
##############################################

// Create the sqlproxy SA
resource "google_service_account" "sqlproxy" {
  account_id   = "sqlproxy"
  display_name = "sqlproxy"
  description  = "Service Account created by Terraform for use with Cloud SQL from GKE cluster"
}

// Create sqlproxy SA key
resource "google_service_account_key" "sqlproxy" {
  service_account_id = google_service_account.sqlproxy.name
}

resource "google_project_iam_member" "cloudsql_client" {
  role   = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.sqlproxy.email}"
}

resource "google_project_iam_member" "cloudsql_admin" {
  role   = "roles/cloudsql.admin"
  member = "serviceAccount:${google_service_account.sqlproxy.email}"
}
