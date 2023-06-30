helm install datadog-agent -f dash/datadog-values.values.yaml --set datadog.apiKey= datadog/datadog

helm upgrade -f dash/datadog-values.yaml 