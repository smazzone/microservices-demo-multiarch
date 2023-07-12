#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start 
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

# Install Kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin

# # Install Kind
# [ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
# chmod +x ./kind
# sudo mv ./kind /usr/local/bin/kind

# Install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin

# Install git
sudo yum install -y git

# Install Skaffold
sudo curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
sudo install skaffold /usr/local/bin/
rm -f skaffold

# install helm
curl -sSL https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# Git clone project
git clone https://github.com/kepicorp/microservices-demo-multiarch.git

# Getting in the repo
cd microservices-demo-multiarch

# Install missing components for minikube with --vm-driver=none
# conntrack
sudo yum install -y conntrack
# cri-tools
VERSION="v1.26.0"
wget https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-$VERSION-linux-amd64.tar.gz
sudo tar zxvf crictl-$VERSION-linux-amd64.tar.gz -C /usr/local/bin
rm -f crictl-$VERSION-linux-amd64.tar.gz
# cri-dockerd
VERSION="0.3.4"
#wget https://github.com/Mirantis/cri-dockerd/releases/download/v${VERSION}/cri-dockerd-${VERSION}.amd64.tgz
#sudo tar zxvf cri-dockerd-${VERSION}.amd64.tgz -C /usr/local/bin
#rm -f cri-dockerd-${VERSION}.amd64.tgz
yum install -y https://github.com/Mirantis/cri-dockerd/releases/download/v${VERSION}/cri-dockerd-${VERSION}-3.el7.x86_64.rpm


# Create k8s local cluster
#kind create cluster --config ./dash/microservices/kind-config.yaml
minikube start

# Add API KEY and APP KEY to kubectl secrets
kubectl create secret generic datadog-secret --from-literal=api-key=$DD_API_KEY --from-literal=app-key=$DD_APP_KEY

# Set hostname
TEAM_NAME=bits
sudo hostnamectl set-hostname $TEAM_NAME-dash2023

# Install agent
helm repo add datadog https://helm.datadoghq.com
helm repo update

# Start agent with datadog-values.yaml
helm install datadog-agent -f dash/datadog-values.yaml datadog/datadog --set datadog.apiKey=$DD_API_KEY

# Skaffold build and run
skaffold build --platform=linux/amd64
skaffold run --platform=linux/amd64

# Forward port 8080 to local machine
kubectl port-forward deployment/frontend 8080:80

# Minikube tunnel out
minikube tunnel

