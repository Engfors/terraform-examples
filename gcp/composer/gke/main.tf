resource "google_container_cluster" "composer_cluster" {
  initial_node_count = 0
  location           = "europe-west3-c"
  logging_service    = "logging.googleapis.com/kubernetes"
  monitoring_service = "monitoring.googleapis.com/kubernetes"
  name               = var.gke_name
  network            = var.composer_network
  node_version       = var.node_version
  project            = var.google_project
  resource_labels = {
    "goog-composer-environment" = var.composer_environment_name
    "goog-composer-location"    = var.google_region
    "goog-composer-version"     = "composer-1-11-3-airflow-1-10-9"
  }
  subnetwork = var.composer_subnetwork

  node_config {
    disk_size_gb = 100
    disk_type    = "pd-standard"
    image_type   = "COS"
    machine_type = var.composer_machine_type
    metadata = {
      "disable-legacy-endpoints" = "true"
    }
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
    service_account = var.service_account
  }

  node_pool {
    initial_node_count = 3
    max_pods_per_node  = 0
    name               = "default-pool"
    node_count         = 3
    node_locations = [
      var.google_zone,
    ]
    version = var.node_version

    management {
      auto_repair  = true
      auto_upgrade = true
    }

    node_config {
      disk_size_gb = 100
      disk_type    = "pd-standard"
      image_type   = "COS"
      machine_type = var.composer_machine_type
      metadata = {
        "disable-legacy-endpoints" = "true"
      }
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
      ]
      service_account = var.service_account
    }

    upgrade_settings {
      max_surge       = 1
      max_unavailable = 0
    }
  }
  node_pool {
    initial_node_count = 1
    max_pods_per_node  = 0
    name               = "scheduler-nodepool"
    node_count         = 1
    node_locations = [
      "europe-west3-c",
    ]
    version = var.node_version

    management {
      auto_repair  = true
      auto_upgrade = true
    }

    node_config {
      disk_size_gb = 100
      disk_type    = "pd-standard"
      image_type   = "COS"
      machine_type = var.scheduler_machine_type
      metadata = {
        "disable-legacy-endpoints" = "true"
      }
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
      ]
      preemptible     = false
      service_account = "default"
      tags            = []
      taint           = []

      shielded_instance_config {
        enable_integrity_monitoring = true
        enable_secure_boot          = false
      }
    }

    upgrade_settings {
      max_surge       = 1
      max_unavailable = 0
    }
  }
}
