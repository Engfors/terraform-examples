resource "google_composer_environment" "example-composer" {
  name    = var.composer_environment_name
  project = var.google_project
  region  = var.google_region

  config {
    node_count = var.composer_worker_node_count

    node_config {
      disk_size_gb = 100
      machine_type = var.composer_machine_type
      network      = var.composer_network
      oauth_scopes = [
        "https://www.googleapis.com/auth/cloud-platform",
      ]
      tags            = []
      zone            = "${var.google_region}-c"
      service_account = var.service_account
    }

    software_config {
      airflow_config_overrides = {
        "celery-worker_concurrency"       = var.celery_worker_concurrency
        "core-parallelism"                = var.celery_worker_concurrency * var.composer_worker_node_count_max
        "core-dag_concurrency"            = var.celery_worker_concurrency * var.composer_worker_node_count_max / 2
        "core-non_pooled_task_slot_count" = var.celery_worker_concurrency * var.composer_worker_node_count_max
        "scheduler-max_threads"           = var.scheduler_max_threads
        // "core-dagbag_import_timeout"            = "180"
        // "core-core-dags_are_paused_at_creation" = "True"
      }
      env_variables = {
        // "GCP_PROJECT_ID" = var.google_project
        "SENDGRID_API_KEY"   = var.sendgrid_api_key
        "SENDGRID_MAIL_FROM" = var.sendgrid_mail_from
      }
      // Leave this commented out to use latest or specify the version you want
      image_version = "composer-1.11.3-airflow-1.10.9"
      pypi_packages = {
        "google-cloud-bigquery-storage" = "==0.7.0"
        "typing-extensions"             = ">=3.7.4.2"
      }
      python_version = "3"
    }
  }
}



// Kubernetes Engine API is requried to be enabled in the project to managede the scheduler nodepool.
resource "google_project_service" "kubernetes_engine_api" {
  project            = var.google_project
  service            = "container.googleapis.com"
  disable_on_destroy = false
}
