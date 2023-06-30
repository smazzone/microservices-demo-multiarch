#!/bin/bash

sudo yum update -y
sudo yum install docker
sudo service start docker
sudo systemctl enable docker
sudo usermod -a -G docker ec2-user

docker run -p 80:8000 -it ctfd/ctfd
