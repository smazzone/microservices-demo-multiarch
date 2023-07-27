#!/bin/bash

echo "reloading configuration"
## Reconfigure agent
echo "> reloading agent with dash/datadog-values.yaml"
helm upgrade datadog-agent -f dash/datadog-values.yaml datadog/datadog
## Restart kubernetes Deployment and Services
echo "> reloading kubernetes cluster"
skaffold run --platform=linux/amd64
echo "> Configuring extras"
# Setting variable to check agent status
export AGENT_POD=$(kubectl get pods | sed -e '/datadog-agent/!d' | sed -n '/cluster/!p' | sed -n '/metrics/!p' | awk -F' ' '{print $1}')
# Configure nginx
export FRONTEND_LB=$(minikube service frontend-lb --url)
sudo -E ./dash/microservices/conf_nginx.sh