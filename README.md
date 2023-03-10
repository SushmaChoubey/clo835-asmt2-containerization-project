# clo835-asmt2-containerization-project

Create K8s cluster, deploy containerized stateless applications using K8s manifests, expose the applications as 
NodePort services, roll out an updated version of the application.

Steps to Run
--------------
1. First we need to copy the shell scripts for running the Kind Cluster into the EC2 environment.  

```scp -i ~/.ssh/schoubeykey init_kind.sh kind.yaml install_httpd.sh ec2_public_ip:/tmp```  
2. Thereafter, we will copy all the Pod, ReplicaSet, Service and Deployment Manifest files into the EC2 environment.  
```scp -i ~/.ssh/schoubeykey pod-manifests/python-app.yaml pod-manifests/mysql-manual.yaml ec2_public_ip:/tmp```  
```scp -i ~/.ssh/schoubeykey replicaset-manifests/mysql-rs.yaml replicaset-manifests/python-app-rs.yaml ec2_public_ip:/tmp```  
```scp -i ~/.ssh/schoubeykey service-manifests/mysql-svc.yaml service-manifests/python-app-svc.yaml ec2_public_ip:/tmp```  
```scp -i ~/.ssh/schoubeykey deployment-manifests/mysql-deployment.yaml deployment-manifests/python-app-deployment.yaml ec2_public_ip:/tmp```  
3. Create K8s cluster using kind tool. First we will login into the EC2 environment using command.  
```ssh -i ~/.ssh/schoubeykey 3.231.94.228```.  
We will go into the tmp folder.  
```cd /tmp```  
Change the permission of script files.  
```chmod 777 init_kind.sh install_httpd.sh```  
Run the K8s cluster  
```./init_kind.sh```  
4. Running the Pod, Service, Replicaset and Deployment using the below script.  
```./install_httpd.sh```  

Verify the Pod, Replicaset, Service and Deployment running on the K8s Cluster.
-------------------------------------------------------------------------------
1. Verify the Pods.  
alias k=kubectl  
k get pod mysql -o yaml -n mysqlpod-namespace  
k logs mysql -n mysqlpod-namespace  
k exec --stdin --tty mysql -n mysqlpod-namespace -- /bin/bash  
mysql -pdb_pass123  
use employees  
select * from employee;  
k get pods -n mysqlpod-namespace  
k get pods -n mypythonpod-namespace  
k logs python-app -n mypythonpod-namespace  
k port-forward python-app -n mypythonpod-namespace 8080:8080  
----In new Terminal-----
ssh -i ~/.ssh/schoubeykey ec2_public_ip  
curl localhost:8080  

2. Verify the Replicaset  
k get rs -n mysqlpod-namespace  
k get rs -n mypythonpod-namespace     

3. Verify the Deployment  
k rollout status deployment.apps/mysql -n  mysqlpod-namespace  
k rollout status deployment.apps/python-app -n  mypythonpod-namespace  

4. Verify the web application is accesible on NodePort 30000
curl localhost:30000


Deletion of All Components
-------------------------------
kubectl delete deployment python-app -n mypythonpod-namespace  
kubectl delete deployment mysql -n mysqlpod-namespace      
kubectl delete replicaset mysql -n mysqlpod-namespace    
kubectl delete replicaset python-app -n mypythonpod-namespace  
kubectl delete svc python-app -n mypythonpod-namespace   
kubectl delete svc mysql -n mysqlpod-namespace  
kubectl delete pod mysql -n mysqlpod-namespace  
kubectl delete pod python-app -n mypythonpod-namespace   