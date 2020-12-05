#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## Second CockroachDB cluster ########\n"

echo "Skupper Network Cluster"

./skupper init

kubectl wait --for=condition=ready pod -l application=skupper
kubectl wait --for=condition=ready pod -l application=skupper-router

./skupper connect token.yaml

kubectl wait --for=condition=ready pod -l application=skupper-router

kubectl wait --for=condition=ready pod/cockroachdb-g1-0
kubectl wait --for=condition=ready pod/cockroachdb-g1-1
kubectl wait --for=condition=ready pod/cockroachdb-g1-2

echo "Deploying the CockroachDB G2 cluster"

kubectl apply -f todo-backend/src/main/kubernetes/cockroachdb-statefulset-g2.yaml

echo "Waiting the CockroachDB G2 cluster"

kubectl wait --for=condition=ready pod/cockroachdb-g2-0
kubectl wait --for=condition=ready pod/cockroachdb-g2-1
kubectl wait --for=condition=ready pod/cockroachdb-g2-2

echo "Skupper Network Cluster"

./skupper expose statefulset cockroachdb-g2 --headless --port 26257 --address cockroachdb-internal-g2
./skupper expose statefulset cockroachdb-g2 --port 26257 --address cockroachdb-public

kubectl wait --for=condition=ready pod/cockroachdb-internal-g2-proxy-0
kubectl wait --for=condition=ready pod/cockroachdb-internal-g2-proxy-1
kubectl wait --for=condition=ready pod/cockroachdb-internal-g2-proxy-2