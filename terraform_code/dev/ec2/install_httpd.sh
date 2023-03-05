#!/bin/bash
#For ping install
sudo yum install iputils -y
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
#Pull the Docker Image from AWS ECR in Kubernetes and creating Secret
aws ecr get-login-password --region us-east-1|kubectl create secret docker-registry regcred --docker-server='983372048879.dkr.ecr.us-east-1.amazonaws.com/clo835-assigmt2-repo' --docker-username=AWS  --docker-email='schoubey1@myseneca.ca' --docker-password=stdin
kubectl get secret regcred --output=yaml
#Namespace for running MYSQL POD MANIFEST
kubectl create ns mysqlpod-namespace
kubectl create -f mysql-manual.yaml -n mysqlpod-namespace
#Wait for MYSQLPOD to be ready
kubectl wait --for=condition=Ready pod/mysql-pod -n mysqlpod-namespace
#Namespace for running PYTHON APP POD MANIFEST
kubectl create ns mypythonpod-namespace
#ConfigMap for Storing MYSQLDB IP Address
kubectl create configmap my-configmap --from-literal=mydb-key=$(kubectl get pod mysql-pod --namespace=mysqlpod-namespace -o jsonpath='{.status.podIP}') -n mypythonpod-namespace
kubectl create -f python-app.yaml -n mypythonpod-namespace
#Replicaset
#kubectl create -f mysql-rs.yaml -n mysqlpod-namespace
#kubectl create configmap my-configmap-rs --from-literal=mydb-key=$(kubectl get replicaset mysql-rs --namespace=mysqlpod-namespace -o jsonpath='{.status.podIP}') -n mypythonpod-namespace
#kubectl create -f python-app-rs.yaml -n mypythonpod-namespace