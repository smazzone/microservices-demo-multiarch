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

# Install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin

# Install git and conntrack
sudo yum install -y git conntrack

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

# Add DD_RUM_ID to the footer for RUM usage
FOOTERFILE="$(pwd)/src/frontend/templates/footer.html"
FOOTERTEMPLATE="$(pwd)/src/frontend/templates/footer-template.html"
sed -e "s/\<RUM_APP_ID\>/$RUM_APP_ID/" $FOOTERTEMPLATE | sed -e "s/\<RUM_CLIENT_TOKEN\>/$RUM_CLIENT_TOKEN/" > $FOOTERFILE

# Create k8s local cluster
minikube start --cpus=4 --memory 8192 

# Add API KEY and APP KEY to kubectl secrets
kubectl create secret generic datadog-secret --from-literal=api-key=$DD_API_KEY --from-literal=app-key=$DD_APP_KEY

# Set hostname
# TEAM_NAME=bits
# sudo hostnamectl set-hostname $TEAM_NAME-dash2023

# Install agent
helm repo add datadog https://helm.datadoghq.com
helm repo add stable https://charts.helm.sh/stable 
helm repo update

# Start agent with datadog-values.yaml
helm install datadog-agent -f dash/datadog-values.yaml datadog/datadog --set datadog.apiKey=$DD_API_KEY

# Skaffold build and run
skaffold build --platform=linux/amd64
skaffold run --platform=linux/amd64

# Forward port 8080 to local machine
IP_ADDR=$(ip addr show enX0 | grep "inet " | awk -F'[:{ /}]+' '{ print $3 }')
kubectl patch svc frontend-external -n default -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${IP_ADDR}\"]}}"

# Add POD Agent pod address
AGENT_POD=$(kubectl get pods | sed -e '/datadog-agent/!d' | sed -n '/cluster/!p' | sed -n '/metrics/!p' | awk -F' ' '{print $1}')
echo "alias datadog-status='kubectl exec \$AGENT_POD -- agent status'" >> ~.bashrc

# add Flag to ENV
echo "export DD_CTF='LEGENDOFBITS_TEARSOFSRE'" >> ~.bashrc
source .bashrc