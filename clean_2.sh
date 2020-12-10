#!/usr/bin/env bash

set -eu 

set -o pipefail

kubectl delete all --all
./skupper delete

kubectl delete pvc datadir-cockroachdb-g2-0
kubectl delete pvc datadir-cockroachdb-g2-1