resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "${var.name}-subnetwork"
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  network       = google_compute_network.vpc.self_link
}
