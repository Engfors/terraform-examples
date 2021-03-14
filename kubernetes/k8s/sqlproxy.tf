resource "kubernetes_service" "sqlproxy" {
  for_each = var.gke_namespaces
  metadata {
    labels = {
      app = "example-sql-proxy"
    }
    name      = "example-sql-proxy-service"
    namespace = kubernetes_namespace.namespaces[each.key].metadata[0].name
    annotations = {
      "cloud.google.com/load-balancer-type" = "Internal"
      "cloud.google.com/neg" = jsonencode(
        {
          ingress = true
        }
      )
    }
  }
  spec {
    external_traffic_policy = "Cluster"
    type                    = "LoadBalancer"
    session_affinity        = "None"

    port {
      port        = 3306
      protocol    = "TCP"
      target_port = 3306
    }

    selector = {
      app = kubernetes_deployment.sqlproxy[each.key].metadata.0.labels.app
    }
  }
}

resource "kubernetes_deployment" "sqlproxy" {
  for_each = var.gke_namespaces
  metadata {
    labels = {
      app = "example-sql-proxy"
    }
    name      = "example-sql-proxy"
    namespace = kubernetes_namespace.namespaces[each.key].metadata[0].name
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "example-sql-proxy"
      }
    }

    template {
      metadata {
        labels = {
          app = "example-sql-proxy"
        }
      }

      spec {
        dns_policy                       = "ClusterFirst"
        restart_policy                   = "Always"
        termination_grace_period_seconds = "30"

        container {
          command = [
            "/cloud_sql_proxy",
            "--dir=/cloudsql",
            "-instances=${local.google_sql_database_instance.connection_name}=tcp:0.0.0.0:3306",
            "-credential_file=/secrets/cloudsql/sqlproxy.json",
          ]
          image                    = "gcr.io/cloudsql-docker/gce-proxy:latest"
          image_pull_policy        = "IfNotPresent"
          name                     = "example-sql-proxy"
          termination_message_path = "/dev/termination-log"

          volume_mount {
            mount_path = "/secrets/cloudsql"
            name       = "example-sql-proxy"
            read_only  = true
          }
          volume_mount {
            mount_path = "/cloudsql"
            name       = "cloudsql"
            read_only  = false
          }
        }

        volume {
          name = "example-sql-proxy"

          secret {
            default_mode = "0644"
            optional     = false
            secret_name  = kubernetes_secret.sqlproxy_secrets[each.key].metadata[0].name
          }
        }
        volume {
          name = "cloudsql"

          empty_dir {}
        }
      }
    }
  }
}
