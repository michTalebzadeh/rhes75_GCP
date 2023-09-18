# Define variables for GCP project

# GCP Project ID
variable "project_id" {
  description = "The ID of your GCP project."
  default = "axial-glow-224522"
}

# GCP Region
variable "region" {
  description = "The GCP region where resources will be created."
  default = "europe-west2"
}

# GCP Zone
variable "zone" {
  description = "The GCP zone where resources will be created."
  default     = "europe-west2-c"
}

# Service Account Key File Path
variable "service_account_key_file" {
  description = "The file path to your GCP service account key JSON file."
  default =  "./GCPFirstProject-d75f1b3a9817.json"
}

# Machine Type
variable "machine_type" {
  description = "The machine type for virtual machines."
  default     = "n1-standard-2"
}

# Number of VM Instances
variable "instance_count" {
  description = "The number of VM instances to create."
  type        = number
  default     = 1
}

# machine and network names

variable "machine_name" {
  description = "vm and subnet names"
  default     = "spark-nex" 
}
