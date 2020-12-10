#!/usr/bin/env bash

set -eu 

set -o pipefail

kubectl delete all --all
./skupper delete

kubectl delete pvc datadir-cockroachdb-g1-0
kubectl delete pvc datadir-cockroachdb-g1-1
kubectl delete pvc datadir-cockroachdb-g1-2
kubectl delete pvc datadir-cockroachdb-g1-3