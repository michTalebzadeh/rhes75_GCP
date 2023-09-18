#!/bin/bash
export REGION="europe-west2"
export DP_CLUSTER="spark-on-gke"
gcloud dataproc jobs submit spark \
    --region=${REGION} \
    --cluster=${DP_CLUSTER} \
    --class=org.apache.spark.examples.SparkPi \
    --jars=gs://axial-glow-224522-spark-on-gke-dataproc/jars/spark-examples_2.12-3.1.1.jar \
    -- 1000
