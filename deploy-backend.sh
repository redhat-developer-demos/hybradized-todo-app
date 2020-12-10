#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## Deploying Backend ########\n"

kubectl apply -f todo-backend/src/main/kubernetes/backend-gcp.yaml

kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=todo-backend
