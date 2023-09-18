#!/bin/bash

export CLUSTER_NAME="spark-on-gke"
export NODEPOOL_NAME="node-pool-for-${CLUSTER_NAME}"
gcloud container node-pools create ${NODEPOOL_NAME} \
    --cluster=${CLUSTER_NAME} \
    --workload-metadata=GKE_METADATA \
    --zone=${ZONE}

