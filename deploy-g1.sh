#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## Main CockroachDB cluster ########\n"

curl -fL https://github.com/skupperproject/skupper/releases/download/0.3.2/skupper-cli-0.3.2-mac-amd64.tgz | tar -xzf -

echo "Deploying the CockroachDB G1 cluster"

kubectl apply -f todo-backend/src/main/kubernetes/cockroachdb-statefulset-g1.yaml

echo "Waiting the CockroachDB G1 cluster"

pStatus=$(kubectl get pod cockroachdb-g1-0 -o jsonpath="{.status.phase}" 2>/dev/null)
 
while [ "$pStatus" != "Running" ]
do   
    echo "\n Waiting for cockroachdb-g1-0 to be created  ...\n"
    sleep 2
    pStatus=$(kubectl get pod cockroachdb-g1-0 -o jsonpath="{.status.phase}" 2>/dev/null)
done

pStatus=$(kubectl get pod cockroachdb-g1-1 -o jsonpath="{.status.phase}" 2>/dev/null)
 
while [ "$pStatus" != "Running" ]
do   
    echo "\n Waiting for cockroachdb-g1-1 to be created  ...\n"
    sleep 2
    pStatus=$(kubectl get pod cockroachdb-g1-1 -o jsonpath="{.status.phase}" 2>/dev/null)
done

pStatus=$(kubectl get pod cockroachdb-g1-2 -o jsonpath="{.status.phase}" 2>/dev/null)
 
while [ "$pStatus" != "Running" ]
do   
    echo "\n Waiting for cockroachdb-g1-2 to be created  ...\n"
    sleep 2
    pStatus=$(kubectl get pod cockroachdb-g1-2 -o jsonpath="{.status.phase}" 2>/dev/null)
done

pStatus=$(kubectl get pod cockroachdb-g1-3 -o jsonpath="{.status.phase}" 2>/dev/null)

while [ "$pStatus" != "Running" ]
do   
    echo "\n Waiting for cockroachdb-g1-3 to be created  ...\n"
    sleep 2
    pStatus=$(kubectl get pod cockroachdb-g1-3 -o jsonpath="{.status.phase}" 2>/dev/null)
done

echo "Init the CockroachDB G1 cluster"

kubectl apply -f todo-backend/src/main/kubernetes/cluster-init-g1.yaml

kubectl wait --for=condition=ready pod/cockroachdb-g1-0
kubectl wait --for=condition=ready pod/cockroachdb-g1-1
kubectl wait --for=condition=ready pod/cockroachdb-g1-2
kubectl wait --for=condition=ready pod/cockroachdb-g1-3

echo "Skupper Network Cluster"

./skupper init

kubectl wait --for=condition=ready pod -l application=skupper
kubectl wait --for=condition=ready pod -l application=skupper-router

echo "Skupper Exposing"

./skupper expose statefulset cockroachdb-g1 --headless --port 26257 --address cockroachdb-internal-g1
./skupper expose statefulset cockroachdb-g1 --port 26257 --address cockroachdb-public

echo "Generate Cloud Token"

./skupper connection-token token.yaml

kubectl wait --for=condition=ready pod/cockroachdb-internal-g1-proxy-0
kubectl wait --for=condition=ready pod/cockroachdb-internal-g1-proxy-1
kubectl wait --for=condition=ready pod/cockroachdb-internal-g1-proxy-2
kubectl wait --for=condition=ready pod/cockroachdb-internal-g1-proxy-3