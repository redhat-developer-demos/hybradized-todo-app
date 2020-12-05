#!/usr/bin/env bash

set -eu 

set -o pipefail

printf "\n\n######## Exposing Todo Frontend ########\n"

oc expose service todo-frontend

hostservice=$(kubectl get route todo-frontend -o jsonpath="{.spec.host}" 2>/dev/null)

echo "App deployed at ${hostservice}/todo.html"