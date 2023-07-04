# Notes Dash 2023

## CTFd

Event name: Partner Summit Dash 2023 - Do the impossible
Desc: Join us for the partner summit @ Dash 2023 we will Do the impossible by instrumenting an entire e-com architecture from zero to observability
Color: 92, 47, 160
Date: Aug 2nd 2023 - 22:30
Finish: Aug 3rd 2023 - 00:00

Internal [documentation](https://datadoghq.atlassian.net/wiki/spaces/PRODUCTSA/pages/2671741230/Datadog+Swagstore+Demo+App)
Dash Repo [kepicorp](https://github.com/kepicorp/microservices-demo-multiarch/tree/pierre-dash-2023)

## Documentation

[Kuberenetes Agent](https://docs.datadoghq.com/containers/kubernetes/)
[Kubernetes Admission Controller](https://docs.datadoghq.com/containers/cluster_agent/admission_controller/?tab=helm)


## Useful Commands

Update datadog-agent configuration
```bash
helm upgrade -f dash/datadog-values.yaml datadog-agent datadog/datadog

Set API Key and APP key
```bash
DD_API_KEY=
DD_APP_KEY=
TEAM_NAME=""
```

## Add from Instruqt training

[Look at this bootstrap and inspire for K8s set up](https://github.com/DataDog/training-images/blob/main/instruqt-k8s/bootstrap.sh)

## TODO

* Redis integration monitoring https://docs.datadoghq.com/containers/kubernetes/integrations/?tab=helm
* Expose 80
* Logs and traces correlation
* Live process
* Continues profiler
* Enable ASM 
```yaml
spec:
  template:
    spec:
      containers:
        - name: <CONTAINER_NAME>
          image: <CONTAINER_IMAGE>/<TAG>
          env:
            - name: DD_APPSEC_ENABLED
              value: "true"
```
