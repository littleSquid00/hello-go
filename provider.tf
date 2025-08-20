terraform {
  required_version = "> 1.8.2"
  required_providers {
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
  image_repository = "hello-go"
  image_tag = "local"
}