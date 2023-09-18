#!/bin/ksh

DATAPROC_CLUSTER="dataproc-for-gke"
GKE_CLUSTER="gke-dataproc"
GCE_REGION="europe-west2"
DATAPROC_CLUSTER="ctpcluster"
VERSION="2.0-debian10"
BUCKET="gkebucket10"
ZONE="europe-west2-c"
IMAGE_VERSION="2.0-debian10"
IMAGE_VERSION="1.4.27-beta"
NAMESPACE="spark"


gcloud beta container --project ${GCPPROJECT} clusters create ${GKE_CLUSTER} --zone ${ZONE} --no-enable-basic-auth --cluster-version "1.19.9-gke.1900" --release-channel "regular" --machine-type "e2-medium" --image-type "COS_CONTAINERD" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --max-pods-per-node "110" --num-nodes "3" --enable-stackdriver-kubernetes --enable-ip-alias --network "projects/axial-glow-224522/global/networks/default" --subnetwork "projects/${GCPPROJECT}/regions/${GCE_REGION}/subnetworks/default" --no-enable-intra-node-visibility --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --enable-shielded-nodes --node-locations ${ZONE}

gcloud beta dataproc clusters create ${DATAPROC_CLUSTER} --gke-cluster=${GKE_CLUSTER} --region ${GCE_REGION} --zone ${ZONE} --master-machine-type n1-standard-4 --master-boot-disk-size 200 --image-version ${IMAGE_VERSION} --project ${GCPPROJECT} --bucket=${BUCKET}

#Created [https://dataproc.googleapis.com/v1beta2/projects/axial-glow-224522/regions/europe-west2/clusters/ctpcluster] Cluster created on GKE cluster projects/axial-glow-224522/locations/europe-west2-c/clusters/gke-dataproc.

gcloud beta dataproc clusters delete ${DATAPROC_CLUSTER} \
    --region=${GCE_REGION}

gcloud beta container clusters delete ${GKE_CLUSTER}  \
  --region=${GCE_REGION}


# jobs

gcloud dataproc jobs submit pyspark \
--cluster=${DATAPROC_CLUSTER} \
  gs://gkebucket10/testme.py \
--region="europe-west2-c"

