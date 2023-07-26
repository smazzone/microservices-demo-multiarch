#!/bin/bash

## Reconfigure agent
helm upgrade datadog-agent -f dash/datadog-values.yaml datadog/datadog
## Restart kubernetes Deployment and Services
skaffold run --platform=linux/arm64