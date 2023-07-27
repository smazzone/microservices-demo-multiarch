#!/bin/bash

## Run as ec2-user when EC2 instance as been booted up and pre-config

# Install kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin

# Install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
sudo mv minikube /usr/local/bin

# Install git and conntrack and nginx (for reverse proxy)
sudo yum install -y git conntrack nginx

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

# Add docker login
cp -rf ./dash/microservices/.docker ~/

# Add DD_RUM_ID to the footer for RUM usage
sed -e "s/RUM_APP_ID/$RUM_APP_ID/" ./src/frontend/templates/footer-template.html | sed -e "s/RUM_CLIENT_TOKEN/$RUM_CLIENT_TOKEN/" > ./src/frontend/templates/footer.html

# Install agent
helm repo add datadog https://helm.datadoghq.com
helm repo add stable https://charts.helm.sh/stable 
helm repo update

## Change motd 
sudo ./dash/microservices/conf_motd.sh

# Forward port 8080 to local machine
#IP_ADDR=$(ip addr show enX0 | grep "inet " | awk -F'[:{ /}]+' '{ print $3 }')
#kubectl patch svc frontend-external -n default -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${IP_ADDR}\"]}}"

# Add POD Agent pod address
cd

# add Flag to ENV
echo "export DD_CTF='LEGENDOFBITS_TEARSOFSRE'" >> .bashrc
source .bashrc


