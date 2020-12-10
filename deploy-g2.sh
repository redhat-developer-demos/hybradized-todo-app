#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## Second CockroachDB cluster ########\n"

echo "Skupper Network Cluster"

./skupper init

kubectl wait --for=condition=ready pod -l application=skupper
kubectl wait --for=condition=ready pod -l application=skupper-router --timeout=90s

./skupper connect token.yaml

kubectl wait --for=condition=ready pod -l application=skupper-router

sleep 10

kubectl wait --for=condition=ready pod/cockroachdb-g1-0 --timeout=90s
kubectl wait --for=condition=ready pod/cockroachdb-g1-1 --timeout=90s
kubectl wait --for=condition=ready pod/cockroachdb-g1-2 --timeout=120s
kubectl wait --for=condition=ready pod/cockroachdb-g1-3 --timeout=120s

echo "Deploying the CockroachDB G2 cluster"

kubectl apply -f todo-backend/src/main/kubernetes/cockroachdb-statefulset-g2.yaml

echo "Waiting the CockroachDB G2 cluster"

kubectl wait --for=condition=ready pod/cockroachdb-g2-0 --timeout=90s
kubectl wait --for=condition=ready pod/cockroachdb-g2-1 --timeout=90s

echo "Skupper Network Cluster"

./skupper expose statefulset cockroachdb-g2 --headless --port 26257 --address cockroachdb-internal-g2
./skupper expose statefulset cockroachdb-g2 --port 26257 --address cockroachdb-public

kubectl wait --for=condition=ready pod/cockroachdb-internal-g2-proxy-0 --timeout=90s
kubectl wait --for=condition=ready pod/cockroachdb-internal-g2-proxy-1 --timeout=90s