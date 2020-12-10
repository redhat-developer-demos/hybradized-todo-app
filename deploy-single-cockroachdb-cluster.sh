#!/usr/bin/env bash

set -eu 

set -o pipefail

echo "Deploying the CockroachDB G1 cluster"

kubectl apply -f todo-backend/src/main/kubernetes/single-cockroachdb-statefulset-cluster.yaml

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

echo "Init the CockroachDB G1 cluster"

kubectl apply -f todo-backend/src/main/kubernetes/cluster-init-g1.yaml

kubectl wait --for=condition=ready pod/cockroachdb-g1-0
kubectl wait --for=condition=ready pod/cockroachdb-g1-1
kubectl wait --for=condition=ready pod/cockroachdb-g1-2