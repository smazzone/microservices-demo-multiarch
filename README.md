
<p align="center">
<img src="src/frontend/static/icons/Swagstore-Logo.svg" width="300" alt="Swagstore" />
</p>

<!-- 
## Release 0.5.0 - multiarch (amd and arm support)
## Dec 2022


**Swagstore** is a fork of [Google Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo) which in turn is a cloud-first microservices demo application.

The app consists of an 11-tier microservices application. The application is a
web-based e-commerce app where users can browse items,
add them to the cart, and purchase them.
It is a ficticious ecommerce swag store, don't expect to receive swags :grinning:

**Google uses this application to demonstrate use of technologies like
Kubernetes/GKE, Istio, Stackdriver, and gRPC**. This application
works on any Kubernetes cluster, as well as Google
Kubernetes Engine. It’s **easy to deploy with little to no configuration**.

**At Datadog we use the app to experiment with APM, Tracing Libraries, Admission Controller and auto injection.
It is perfect as a playground if you want to play and instrument the microservices written in multiple languages.**

If you’re using this demo, please **★Star** this repository to show your interest!




## Features

- **[Kubernetes](https://kubernetes.io)/[GKE](https://cloud.google.com/kubernetes-engine/):**
  The app is designed to run on Kubernetes (both locally on "Docker for
  Desktop", as well as on the cloud with GKE).
- **[gRPC](https://grpc.io):** Microservices use a high volume of gRPC calls to
  communicate to each other.
- **[Istio](https://istio.io):** Application works on Istio service mesh.
- **[Cloud Operations (Stackdriver)](https://cloud.google.com/products/operations):** Many services
  are instrumented with **Profiling**, **Tracing** and **Debugging**. In
  addition to these, using Istio enables features like Request/Response
  **Metrics** and **Context Graph** out of the box. When it is running out of
  Google Cloud, this code path remains inactive.
- **[Skaffold](https://skaffold.dev):** Application
  is deployed to Kubernetes with a single command using Skaffold.
- **Synthetic Load Generation:** The application demo comes with a background
  job that creates realistic usage patterns on the website using
  [Locust](https://locust.io/) load generator.
  
  
## Deploy Swagstore Demo app

Do you have a running K8s cluster? If not either use Docker Desktop or Minikube or Kind or your K8s cluster or your GKE

Don't forget to install Git, Skaffold 2.0+ and kubectl. Check the prerequisites section above.

Launch a local Kubernetes cluster with one of the following tools:

## Option 1 - Local Cluster 

1. Launch a local Kubernetes cluster with one of the following tools:

    - To launch **Minikube** (tested with Ubuntu Linux). Please, ensure that the
       local Kubernetes cluster has at least:
        - 4 CPUs
        - 4.0 GiB memory
        - 32 GB disk space

      ```shell
      minikube start --cpus=4 --memory 4096 --disk-size 32g
      ```

    - To launch **Docker for Desktop** (tested with Mac/Windows). Go to Preferences:
        - choose “Enable Kubernetes”,
        - set CPUs to at least 3, and Memory to at least 6.0 GiB
        - on the "Disk" tab, set at least 32 GB disk space

    - To launch a **Kind** cluster:

      ```shell
      kind create cluster
      ```

2. Run `kubectl get nodes` to verify you're connected to the respective control plane.

3. Run `skaffold run` (first time will be slow, it can take ~20 minutes).
   This will build and deploy the application. If you need to rebuild the images
   automatically as you refactor the code, run `skaffold dev` command.
   
   
	**change the platform accordingly**
	
	**change the default-repo to point to your personal hub account
	if you want to use your own images or you can use mine**
	
	if you are on Mac M1 or M2 or you are on arm use the --platform accordingly

	  `skaffold run --default-repo docker.io/smazzone --platform=linux/arm64`
	
	if you are on a PC or an Intel-based Mac or you are on amd use the --platform accordingly
  
    `skaffold run --default-repo docker.io/smazzone --platform=linux/amd64`
   

4. Run `kubectl get pods` to verify the Pods are ready and running.

5. Docker Desktop should automatically provide the frontend at http://localhost:80
6. Minikube requires you to run a command to access the frontend service:
`minikube service frontend-external`
7. Kind does not provision an IP address for the service. You must run a port-forwarding process to access the frontend at http://localhost:8080:
`kubectl port-forward deployment/frontend 8080:8080` to forward a port to the frontend service.
9. Navigate to either http://localhost:80 or http://localhost:8080 to access the web frontend.


## Cleanup

If you've deployed the application with `skaffold run` command, you can run
`skaffold delete` to clean up the deployed resources.

  
## Option 2: Google Kubernetes Engine (GKE)

> 💡 Recommended if you're using Google Cloud Platform and want to try it on
> a realistic cluster. **Note**: If your cluster has Workload Identity enabled, 
> [see these instructions](https://cloud.google.com/kubernetes-engine/docs/how-to/workload-identity#enable)

1.  Create a Google Kubernetes Engine cluster and make sure `kubectl` is pointing
    to the cluster.

    ```sh
    gcloud services enable container.googleapis.com
    ```

    ```sh
    gcloud container clusters create demo --enable-autoupgrade \
        --enable-autoscaling --min-nodes=3 --max-nodes=10 --num-nodes=5 --zone=us-central1-a
    ```

    ```
    kubectl get nodes
    ```

2.  Enable Google Container Registry (GCR) on your GCP project and configure the
    `docker` CLI to authenticate to GCR:

    ```sh
    gcloud services enable containerregistry.googleapis.com
    ```

    ```sh
    gcloud auth configure-docker -q
    ```

3.  In the root of this repository, run `skaffold run --default-repo=gcr.io/[PROJECT_ID]`,
    where [PROJECT_ID] is your GCP project ID.

    This command:

    - builds the container images
    - pushes them to GCR
    - applies the `./kubernetes-manifests` deploying the application to
      Kubernetes.

    **Troubleshooting:** If you get "No space left on device" error on Google
    Cloud Shell, you can build the images on Google Cloud Build: [Enable the
    Cloud Build
    API](https://console.cloud.google.com/flows/enableapi?apiid=cloudbuild.googleapis.com),
    then run `skaffold run -p gcb --default-repo=gcr.io/[PROJECT_ID]` instead.

4.  Find the IP address of your application, then visit the application on your
    browser to confirm installation.

        kubectl get service frontend-external

## Local Development

If you would like to contribute features or fixes to this app, see the [Development Guide](/docs/development-guide.md) on how to build this demo locally.

---
-->

# DASH 2023 - DPN - Fun time with Swagstore

Welcome to Dash 2023 - Datadog Partner Network Challenge !!
Your goal will be to capture all the flags related to a micro-service architected application called **Swagstore** using Datadog.

The app consists of an 11-tier microservices application. The application is a web-based e-commerce app where users can browse items, add them to the cart, and purchase them.
It is a fictitious e-commerce swag store, don't expect to receive swags :grinning:

## Screenshots

| Home Page                                                                                                         | Checkout Screen                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| [![Screenshot of store homepage](./dash/static/online-boutique-frontend-1.png)](./dash/static/online-boutique-frontend-1.png) | [![Screenshot of checkout screen](./dash/static/online-boutique-frontend-2.png)](./dash/static/online-boutique-frontend-2.png) |


## Architecture

The application is running on a single node kubernetes cluster using minikube

[![Architecture of
microservices](./dash/static/arch.png)](./dash/static/arch.png)


| Service                                              | Language      | Description                                                                                                                       |
| ---------------------------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| [frontend](./src/frontend)                           | Go            | Exposes an HTTP server to serve the website. Does not require signup/login and generates session IDs for all users automatically. |
| [cartservice](./src/cartservice)                     | C#            | Stores the items in the user's shopping cart in Redis and retrieves it.                                                           |
| [productcatalogservice](./src/productcatalogservice) | Go            | Provides the list of products from a JSON file and ability to search products and get individual products.                        |
| [currencyservice](./src/currencyservice)             | Node.js       | Converts one money amount to another currency. Uses real values fetched from European Central Bank. It's the highest QPS service. |
| [paymentservice](./src/paymentservice)               | Java          | Charges the given credit card info (mock) with the given amount and returns a transaction ID.                                     |
| [shippingservice](./src/shippingservice)             | Go            | Gives shipping cost estimates based on the shopping cart. Ships items to the given address (mock)                                 |
| [emailservice](./src/emailservice)                   | Python        | Sends users an order confirmation email (mock).                                                                                   |
| [checkoutservice](./src/checkoutservice)             | Go            | Retrieves user cart, prepares order and orchestrates the payment, shipping and the email notification.                            |
| [recommendationservice](./src/recommendationservice) | Python        | Recommends other products based on what's given in the cart.                                                                      |
| [adservice](./src/adservice)                         | Java          | Provides text ads based on given context words.                                                                                   |
| [loadgenerator](./src/loadgenerator)                 | Python/Locust | Continuously sends requests imitating realistic user shopping flows to the frontend.                                              |


## How to ?

The datadog cluster agent configuration is in `dash/datadog-values.yaml`.
All configuration `yaml` file for each services are in `kubernetes-manifests` directory.

The only script you should need is `update.sh` to reload all configurations.

## Useful command

Get all pods running
```bash
kubectl get pods
```

Get all services running
```bash
kubectl get svc
```

Check the status of *datadog-agent*
(Technically you can run any agent command from there including *agent configcheck* for example)
```bash
kubectl exec $AGENT_POD -- agent status
```

If the control plane goes down you can restart it with
```bash
minikube start
```

## Points scoring

> Points
> * Great Plateu - 15 points
> * Main Quests  - 80 points
> * Side Quests  - 140 points
> * Total        - 235 points

## Misc

**Swagstore** is a heavily modified version from the original [Online Boutique](https://github.com/GoogleCloudPlatform/microservices-demo). In fact, items on the Swagstore are actually Datadog swags.