provider "google" {
  credentials = file(var.service_account_key_file)
  project    = var.project_id
  region     = var.region
  zone       = var.zone
}

resource "google_compute_instance" "vm_instance" {
  name         = var.vm_instance_name
  machine_type = var.machine_type

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
  name                    = var.network_name
  auto_create_subnetworks = true
}
