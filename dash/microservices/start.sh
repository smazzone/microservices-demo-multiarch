#!/bin/bash

echo "Starting..."
## Start Minikube
echo "> Creation of Minikube"
minikube start --cpus=4 --memory 8192 
kubectl create secret generic datadog-secret --from-literal=api-key=$DD_API_KEY --from-literal=app-key=$DD_APP_KEY
## Reconfigure agent
echo "> Setting up of datadog-agent"
helm install datadog-agent -f dash/datadog-values.yaml datadog/datadog --set datadog.apiKey=$DD_API_KEY
## Restart kubernetes Deployment and Services
echo "> (Building) Running micro-services"
# Skaffold build and run
skaffold build --platform=linux/amd64
skaffold run --platform=linux/amd64

echo "> Configuring extras"
# Setting variable to check agent status
AGENT_POD=$(kubectl get pods | sed -e '/datadog-agent/!d' | sed -n '/cluster/!p' | sed -n '/metrics/!p' | awk -F' ' '{print $1}')
# Configure nginx
FRONTEND_LB=$(minikube service frontend-lb)
sudo sed -e "s/\<FRONTEND_LB\>/$FRONTEND_LB/" ./dash/nginx.conf > /etc/nginx/nginx.conf
sudo systemctl restart nginx