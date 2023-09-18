#!/bin/bash
export REGION="europe-west2"
export DP_CLUSTER="spark-on-gke"
gcloud dataproc jobs submit pyspark \
    --region=${REGION} \
    --cluster=${DP_CLUSTER} \
    gs://axial-glow-224522-spark-on-gke-dataproc/python/pi.py \
    -- 10

