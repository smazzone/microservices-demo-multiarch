#!/bin/bash

## Stop skaffold
skaffold delete
helm uninstall datadog-agent
minikube stop