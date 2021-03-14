resource "google_project_service" "service" {
  for_each                   = var.active_api
  service                    = each.key
  disable_dependent_services = false
}
