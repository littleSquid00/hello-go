resource "google_compute_network" "vpc_01" {
  name                    = "vpc-01"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "gke_nane1" {
  name          = "gke-northamerica-northeast1"
  ip_cidr_range = "10.0.0.0/20"                 # Nodes
  region        = var.location
  network       = google_compute_network.vpc_01.name

  secondary_ip_range {
    range_name    = "northamerica-northeast1-gke-01-pods"
    ip_cidr_range = "10.16.0.0/17"              # Pods
  }

  secondary_ip_range {
    range_name    = "northamerica-northeast1-gke-01-services"
    ip_cidr_range = "10.20.0.0/20"              # Services
  }
}

module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 38.0"

  project_id = var.project_id
  name       = "main"
  region     = var.location
  network    = google_compute_network.vpc_01.name
  subnetwork = google_compute_subnetwork.gke_nane1.name

  ip_range_pods          = "northamerica-northeast1-gke-01-pods"
  ip_range_services      = "northamerica-northeast1-gke-01-services"
  create_service_account = true
  grant_registry_access  = true
  service_account_name   = "gke-main-service-account"
  deletion_protection    = false
  dns_allow_external_traffic = true
}