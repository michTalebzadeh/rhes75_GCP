#!/bin/bash
gcloud container node-pools delete spark-on-gke \
    --cluster spark-on-gke \
    --zone ${ZONE} \
    --quiet

