#!/usr/bin/env bash

set -eu 

set -o pipefail

curl -fL https://github.com/skupperproject/skupper/releases/download/${SKUPPER_VERSION}/skupper-cli-${SKUPPER_VERSION}-mac-amd64.tgz | tar -xzf -

echo "Skupper Network Cluster"

./skupper init

sleep 10

kubectl wait --for=condition=ready pod -l application=skupper
kubectl wait --for=condition=ready pod -l application=skupper-router --timeout=90s

echo "Skupper Exposing"

./skupper expose statefulset cockroachdb-g1 --port 26257 --address cockroachdb-public

echo "Generate Cloud Token"

./skupper connection-token token.yaml