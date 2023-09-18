provider "google" {
  credentials = file(var.service_account_key_file)
  project    = var.project_id
  region     = var.region
  zone       = var.zone
}

resource "google_compute_instance" "vm_instance" {
  name         = var.machine_name
  machine_type = "e2-micro"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    access_config {
    }
  }
}

resource "google_compute_network" "vpc_network" {
  name                    = var.machine_name
  auto_create_subnetworks = true
}
