# clo835-asmt2-containerization-project
scp -i ~/.ssh/schoubeykey init_kind.sh kind.yaml install_httpd.sh 34.239.227.60:/tmp
scp -i ~/.ssh/schoubeykey pod-manifests/python-app.yaml pod-manifests/mysql-manual.yaml 34.239.227.60:/tmp
scp -i ~/.ssh/schoubeykey replicaset-manifests/mysql-rs.yaml replicaset-manifests/python-app-rs.yaml 34.239.227.60:/tmp
scp -i ~/.ssh/schoubeykey service-manifests/mysql-svc.yaml service-manifests/python-app-svc.yaml 34.239.227.60:/tmp
scp -i ~/.ssh/schoubeykey deployment-manifests/mysql-deployment.yaml deployment-manifests/python-app-deployment.yaml 34.239.227.60:/tmp
ssh -i ~/.ssh/schoubeykey 34.239.227.60
cd /tmp
chmod 777 init_kind.sh install_httpd.sh
./init_kind.sh
./install_httpd.sh
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
ssh -i ~/.ssh/schoubeykey 34.239.227.60
curl localhost:8080
-----Replicaset
k get all -n mysqlpod-namespace
k get all -n mypythonpod-namespace 
k exec --stdin --tty mysql-6c8c7845-r4tmn -n mysqlpod-namespace -- /bin/bash
k port-forward python-app-dkk9g -n mypythonpod-namespace 8081:8080
k exec --stdin --tty python-app-dkk9g -n mypythonpod-namespace -- /bin/bash
-----Deployment
k rollout status deployment.apps/mysql -n  mysqlpod-namespace
k rollout status deployment.apps/python-app -n  mypythonpod-namespace
curl localhost:30000