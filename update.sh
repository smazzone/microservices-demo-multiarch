#!/bin/bash

echo "reloading configuration"
## Reconfigure agent
echo "> reloading agent with dash/datadog-values.yaml"
helm upgrade datadog-agent -f dash/datadog-values.yaml datadog/datadog
## Restart kubernetes Deployment and Services
echo "> reloading kubernetes cluster"
skaffold run --platform=linux/amd64