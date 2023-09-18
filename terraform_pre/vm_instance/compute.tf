# Create a new instance
resource "google_compute_instance" "vm_instance" {
  name         = "michboy"
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    # A default network is created for all GCP projects
    network = "default"
    subnetwork = "default"    
    access_config {
    }
  }
}
