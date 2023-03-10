#!/bin/bash
#ECR Repository
export ECR=983372048879.dkr.ecr.us-east-1.amazonaws.com/clo835-assigmt2-repo
###########Verify the cluster in running############################################################
kubectl get nodes
#Login into ECR repository
aws ecr get-login-password --region us-east-1 |sudo docker login -u AWS ${ECR} --password-stdin
#Pull the Docker Image from AWS ECR in Kubernetes and creating Secret
aws ecr get-login-password --region us-east-1|kubectl create secret docker-registry regcred --docker-server='983372048879.dkr.ecr.us-east-1.amazonaws.com/clo835-assigmt2-repo' --docker-username=AWS  --docker-email='schoubey1@myseneca.ca' --docker-password=stdin
kubectl get secret regcred --output=yaml
###########Deploy MySQL and web applications as pods in their respective namespaces.#################
#Namespace for running MYSQL POD MANIFEST
kubectl create ns mysqlpod-namespace
kubectl create -f mysql-manual.yaml -n mysqlpod-namespace
#Created Database Service
kubectl create -f mysql-svc.yaml -n mysqlpod-namespace
#Wait for MYSQLPOD to be ready
kubectl wait --for=condition=Ready pod/mysql -n mysqlpod-namespace
#Namespace for running PYTHON APP POD MANIFEST
kubectl create ns mypythonpod-namespace
#ConfigMap for Storing MYSQLDB Service Cluster IP
kubectl create configmap mysqldb-configmap --from-literal=database_url=$(kubectl get svc mysql -n mysqlpod-namespace -o jsonpath='{.spec.clusterIP}') -n mypythonpod-namespace
#Create Python Web Application Pod
kubectl create -f python-app.yaml -n mypythonpod-namespace
######################Connect to the server running in the application pod and get a valid response.###################
#kubectl port-forward python-app -n mypythonpod-namespace 8080:8080  
#----In new Terminal-----
#ssh -i ~/.ssh/schoubeykey ec2_public_ip  
#curl localhost:8080

#################Examine the logs of the invoked application to demonstrate the response from the server 
#was reflected in the log file
kubectl logs python-app -n mypythonpod-namespace  

#########Deploy ReplicaSets of the web application with 3 replicas using ReplicaSet manifest. 
#Use the “app:employees” label to create ReplicaSets for web application. Is the pod created in step 2
#governed by the ReplicaSet you created. Explain. Use the “app:mysql” label to create ReplicaSets 
#for MySQL application.###########################################################

#Replicaset
kubectl create -f mysql-rs.yaml -n mysqlpod-namespace
kubectl create -f python-app-rs.yaml -n mypythonpod-namespace

#########Create deployments of MySQL and web applications using deployment manifests.
########a. Use the labels from step 3 as selectors in the deployment manifest.
########b. Is the replicaset created in step 3 part of this deployment? Explain. 
#Deployment
kubectl create -f mysql-deployment.yaml -n mysqlpod-namespace
kubectl create -f python-app-deployment.yaml -n mypythonpod-namespace
#Verify the successful deployment using the command.
kubectl rollout status deployment.apps/mysql -n  mysqlpod-namespace  
kubectl rollout status deployment.apps/python-app -n  mypythonpod-namespace  

#Creating NodePort Service
kubectl create -f python-app-svc.yaml -n mypythonpod-namespace

#The ClusterIP service listens on port 8080. We will forward local port 8080 to service port 8080 with port-forward.
#kubectl port-forward svc/python-app 8080:8080 -n mypythonpod-namespace

#Verify Service
kubectl get svc -n mysqlpod-namespace
kubectl get svc -n mypythonpod-namespace

########Expose web application on NodePort 30000 using service manifest. Demonstrate that you can reach the
#####application from your Amazon EC2 instance using curl and from the browser.
#curl localhost:8080
#curl localhost:30000

########Update the image version in the deployment manifest and deploy a new version of web application. 
###Demonstrate that the new version is running in the cluster using kubectl.
####In python-app-deployment.yaml change image version to "my_app_img_version2"
kubectl apply -f python-app-deployment.yaml -n mypythonpod-namespace
kubectl rollout status deployment.apps/python-app -n  mypythonpod-namespace

###Explain the reason we are using different service types for the web and MySQL applications