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

# Add DD_RUM_ID to the footer for RUM usage
FOOTERFILE="$(pwd)/src/frontend/templates/footer.html"
FOOTERTEMPLATE="$(pwd)/src/frontend/templates/footer-template.html"
sed -e "s/\<RUM_APP_ID\>/$RUM_APP_ID/" $FOOTERTEMPLATE > $FOOTERFILE

# Install agent
helm repo add datadog https://helm.datadoghq.com
helm repo add stable https://charts.helm.sh/stable 
helm repo update

# Forward port 8080 to local machine
#IP_ADDR=$(ip addr show enX0 | grep "inet " | awk -F'[:{ /}]+' '{ print $3 }')
#kubectl patch svc frontend-external -n default -p "{\"spec\": {\"type\": \"LoadBalancer\", \"externalIPs\":[\"${IP_ADDR}\"]}}"

# Allowing scripts to be executed and starting service
chmod u+x *.sh

# Add POD Agent pod address
cd
echo "alias datadog-status='kubectl exec \$AGENT_POD -- agent status'" >> ~.bashrc

# add Flag to ENV
echo "export DD_CTF='LEGENDOFBITS_TEARSOFSRE'" >> .bashrc
source .bashrc
