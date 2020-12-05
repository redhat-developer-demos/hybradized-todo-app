#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## Deploying Frontend ########\n"

kubectl apply -f todo-frontend/src/main/kubernetes/frontend.yaml

kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=todo-frontend