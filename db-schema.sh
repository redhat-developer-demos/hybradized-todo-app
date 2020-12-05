#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## Create Schema CockroachDB cluster ########\n"

kubectl apply -f todo-backend/src/main/kubernetes/database-creation.yaml

kubectl wait --for=condition=complete job/todo-schema