// Add sa credentials as a GKE secret to default namespace
resource "kubernetes_secret" "sa-default" {
  metadata {
    name      = "sa-credentials"
    namespace = kubernetes_namespace.prod.metadata[0].name
  }
  data = {
    "sqlproxy.json" = base64decode(google_service_account_key.sa_key.private_key)
  }
}
