resource "kubernetes_namespace" "this" {
  metadata { name = "hello-go-namespace" }
}

resource "kubernetes_secret" "this" {
  metadata {
    name      = "hello-go-secret"
    namespace = kubernetes_namespace.this.metadata[0].name
  }
  data = {
    GREETING_NAME = var.greeting_secret
  }
}

resource "helm_release" "this" {
  repository       = "https://stakater.github.io/stakater-charts"
  name             = "hello-go"
  chart            = "application"
  version          = "6.0.0"
  create_namespace = false
  namespace        = kubernetes_namespace.this.metadata[0].name
  values = [
    templatefile("values.yml", {
      env_secret_name  = kubernetes_secret.this.metadata[0].name
      image_repository = local.image_repository
      image_tag        = local.image_tag
    })
  ]
}
