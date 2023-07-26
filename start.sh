#!/bin/bash

## Start Minikube
minikube start --cpus=4 --memory 8192 
## Reconfigure agent
helm install datadog-agent -f dash/datadog-values.yaml datadog/datadog
## Restart kubernetes Deployment and Services
skaffold run --platform=linux/arm64