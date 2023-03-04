#!/bin/bash
set -ex
sudo yum update -y
sudo yum install docker -y
#For ping install
sudo yum install iputils -y
sudo systemctl start docker
sudo usermod -a -G docker ec2-user
curl -sLo kind https://kind.sigs.k8s.io/dl/v0.11.0/kind-linux-amd64
sudo install -o root -g root -m 0755 kind /usr/local/bin/kind
rm -f ./kind
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm -f ./kubectl
kind create cluster --config kind.yaml
#For Images Download
export ECR=983372048879.dkr.ecr.us-east-1.amazonaws.com/clo835-assigmt2-repo
export DB_IMG=my_db_img
export APP_IMG=my_app_img
export DBPORT=3306
export DBUSER=root
export DATABASE=employees
export DBPWD=db_pass123
#Login into ECR repository
aws ecr get-login-password --region us-east-1 |sudo docker login -u AWS ${ECR} --password-stdin
EOF