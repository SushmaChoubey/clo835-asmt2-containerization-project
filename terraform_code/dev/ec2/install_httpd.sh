#!/bin/bash
#ECR Repository
export ECR=983372048879.dkr.ecr.us-east-1.amazonaws.com/clo835-assigmt2-repo
#Login into ECR repository
aws ecr get-login-password --region us-east-1 |sudo docker login -u AWS ${ECR} --password-stdin
#Pull the Docker Image from AWS ECR in Kubernetes and creating Secret
aws ecr get-login-password --region us-east-1|kubectl create secret docker-registry regcred --docker-server='983372048879.dkr.ecr.us-east-1.amazonaws.com/clo835-assigmt2-repo' --docker-username=AWS  --docker-email='schoubey1@myseneca.ca' --docker-password=stdin
kubectl get secret regcred --output=yaml
#Namespace for running MYSQL POD MANIFEST
kubectl create ns mysqlpod-namespace
kubectl create -f mysql-manual.yaml -n mysqlpod-namespace
kubectl create -f mysql-svc.yaml -n mysqlpod-namespace
#Wait for MYSQLPOD to be ready
kubectl wait --for=condition=Ready pod/mysql -n mysqlpod-namespace
#Namespace for running PYTHON APP POD MANIFEST
kubectl create ns mypythonpod-namespace
#ConfigMap for Storing MYSQLDB Service Cluster IP
kubectl create configmap mysqldb-configmap --from-literal=database_url=$(kubectl get svc mysql -n mysqlpod-namespace -o jsonpath='{.spec.clusterIP}') -n mypythonpod-namespace
kubectl create -f python-app.yaml -n mypythonpod-namespace
#Replicaset
kubectl create -f mysql-rs.yaml -n mysqlpod-namespace
kubectl create -f python-app-rs.yaml -n mypythonpod-namespace
#Deployment
kubectl create -f mysql-deployment.yaml -n mysqlpod-namespace
kubectl create -f python-app-deployment.yaml -n mypythonpod-namespace
#Creating NodePort Service
kubectl create -f python-app-svc.yaml -n mypythonpod-namespace
#kubectl port-forward svc/python-app 8080:8080 -n mypythonpod-namespace

#Deletion
k delete deployment python-app -n mypythonpod-namespace
k delete deployment mysql -n mysqlpod-namespace  
k delete replicaset mysql -n mysqlpod-namespace  
k delete replicaset python-app -n mypythonpod-namespace
k delete svc python-app -n mypythonpod-namespace 
k delete svc mysql -n mysqlpod-namespace
k delete pod mysql -n mysqlpod-namespace
k delete pod python-app -n mypythonpod-namespace 