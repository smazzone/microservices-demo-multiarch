#!/bin/bash

## Running as ROOT when EC2 instance start
# Installing docker and enabling ec2-user for it

yum update -y
yum install docker -y
service docker start 
systemctl enable docker
usermod -a -G docker ec2-user
