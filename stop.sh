#!/bin/bash

echo "stopping..."
## Stop skaffold
echo "> stopping kubernetes"
skaffold delete
echo "> stopping agent"
helm uninstall datadog-agent
echo "> stopping minikube"
minikube stop