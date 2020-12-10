#!/usr/bin/env bash

set -eu 

set -o pipefail

curl -fL https://github.com/skupperproject/skupper/releases/download/0.3.2/skupper-cli-0.3.2-mac-amd64.tgz | tar -xzf -

echo "Skupper Network Cluster"

./skupper init

sleep 10

kubectl wait --for=condition=ready pod -l application=skupper
kubectl wait --for=condition=ready pod -l application=skupper-router --timeout=90s

./skupper connect token.yaml

kubectl wait --for=condition=ready pod -l application=skupper-router