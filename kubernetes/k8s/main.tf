##############################################
#         STATIC IP FOR INGRESS LB           #
##############################################
resource "google_compute_global_address" "ingress_address" {
  for_each = var.gke_namespaces
  name     = each.key
}

##############################################
#          KUBERNETES NAMESPACES             #
##############################################

resource "kubernetes_namespace" "namespaces" {
  for_each = var.gke_namespaces

  metadata {
    name = each.key
  }
}

##############################################
#           KUBERNETES SECRETS               #
##############################################

resource "kubernetes_secret" "sqlproxy_secrets" {
  for_each = var.gke_namespaces

  metadata {
    name      = "cloudsql-proxy-credentials"
    namespace = each.key
  }
  data = {
    "sqlproxy.json" = base64decode(local.sqlproxy_key)
  }
}

resource "kubernetes_secret" "properties_bucket_key" {
  for_each = var.gke_namespaces

  metadata {
    name      = "properties-bucket-key"
    namespace = each.key
  }
  data = {
    "properties_bucket_key.json" = base64decode(google_service_account_key.properties_bucket_key[each.key].private_key)
  }
}

##############################################
#                 GCP SA                     #
##############################################
// Create the properties bucket SA
resource "google_service_account" "properties_bucket_sa" {
  for_each = var.gke_namespaces

  account_id   = "${each.key}-bucket-sa"
  display_name = "${each.key}-bucket-sa"
  description  = "Service Account created by Terraform for use with Properties Bucket"
}

// Create properties bucket SA key
resource "google_service_account_key" "properties_bucket_key" {
  for_each           = var.gke_namespaces
  service_account_id = google_service_account.properties_bucket_sa[each.key].name
}

##############################################
#            KUBERNETES SERVICE               #
##############################################
resource "kubernetes_service" "example_service" {
  for_each = var.gke_namespaces

  metadata {
    name      = "${each.key}-service"
    namespace = kubernetes_namespace.namespaces[each.key].metadata[0].name
    labels = {
      app = each.key
    }
  }
  spec {
    port {
      port        = 80
      target_port = 8080
    }
    selector = {
      app = each.key
    }
    type = "NodePort"
  }
}

##############################################
#           KUBERNETES INGRESS               #
##############################################
resource "kubernetes_ingress" "http_ingress" {
  for_each = var.http_ingress

  metadata {
    name      = "${each.key}-ingress"
    namespace = each.key
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.ingress_address[each.key].name
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.example_service[each.key].metadata[0].name
            service_port = "80"
          }
        }
      }
    }
  }
  depends_on = [google_compute_global_address.ingress_address]
}

resource "kubernetes_ingress" "https_ingress" {
  for_each = var.https_ingress

  metadata {
    name      = "${each.value["deployment"]}-ingress"
    namespace = each.value["namespace"]
    annotations = {
      "kubernetes.io/ingress.global-static-ip-name" = google_compute_global_address.ingress_address[each.value["deployment"]].name
      "networking.gke.io/managed-certificates"      = each.value["cert"]
      "kubernetes.io/ingress.allow-http"            = "false"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.example_service[each.value["deployment"]].metadata[0].name
            service_port = "80"
          }
        }
      }
    }
  }
  depends_on = [google_compute_global_address.ingress_address]
}
