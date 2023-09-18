#!/bin/bash
gcloud container --project "axial-glow-224522" clusters create-auto "spark-on-gke" --region "europe-west2" --release-channel "regular" --network "projects/axial-glow-224522/global/networks/default" --subnetwork "projects/axial-glow-224522/regions/europe-west2/subnetworks/default" --cluster-ipv4-cidr "/17"
