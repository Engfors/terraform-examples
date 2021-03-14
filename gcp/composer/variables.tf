variable "google_project" {
  type        = string
  description = "Sets the GCP project used by this workspace"
}

variable "google_region" {
  default = "europe-west1"
}

variable "composer_worker_node_count" {
  type        = number
  description = "Number of worker nodes"
  default     = 3
}

variable "composer_worker_node_count_max" {
  type        = number
  description = "Maximum number of worker nodes"
  default     = 3
}

variable "scheduler_max_threads" {
  type        = string
  description = "Max number of threads for the scheduler"
  default     = "8"
}

variable "celery_worker_concurrency" {
  type    = number
  default = 18
}

variable "composer_environment_name" {
  type        = string
  description = "The name of the environment you want to create"
}

variable "composer_network" {
  type        = string
  description = "Network used by composer"
}

variable "service_account" {
  type        = string
  description = "Service account used by composer"
}

variable "composer_machine_type" {
  type        = string
  description = "Machine type used by composer"
}

variable "sendgrid_api_key" {
  type = string
}
variable "sendgrid_mail_from" {
  type        = string
  description = "(optional) describe your variable"
}
