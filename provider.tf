terraform {
  required_version = ">= 1.8.2"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.16.0"
    }
  }
}

locals {
  image_repository = "northamerica-northeast1-docker.pkg.dev/athack-ctf-2025/docker/hello-go"
  image_tag = "latest"
}

provider "google" {
  project = var.project_id
}

data "google_client_config" "this" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint_dns}"
  token                  = data.google_client_config.this.access_token
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint_dns}"
    token                  = data.google_client_config.this.access_token
  }
}
