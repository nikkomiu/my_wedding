#!/bin/bash

echo "Downloading kubectl..."

curl -O https://storage.googleapis.com/kubernetes-release/release/v1.3.4/bin/linux/amd64/kubectl
mv kubectl /usr/bin
chmod +x /usr/bin/kubectl

echo "Creating cluster config..."

kubectl config set-cluster primary \
  --server=$SERVER \
  --insecure-skip-tls-verify=true \

kubectl config set-credentials deployer \
  --token=$BEARER_TOKEN

kubectl config set-context primary-system \
  --cluster=primary \
  --user=deployer \
  --namespace=$CLUSTER

kubectl config use-context primary-system

if [ "$CLUSTER" = "production" ]
then
  echo "Starting rolling update of RC..."
  kubectl rolling-update $SERVICE_NAME --image=$DOCKER_IMAGE

elif [ "$CLUSTER" = "staging" ]
then
  echo "Starting pod deletion..."
  # Drop containers one by one for the service
else
  echo "ERROR: Cluster not specified!"

  exit 0
fi
