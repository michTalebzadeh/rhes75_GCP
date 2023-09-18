#!/bin/bash
gcloud container clusters update spark-on-gke \
    --zone=${ZONE} \
    --workload-pool=${PROJECT_ID}.svc.id.goog

