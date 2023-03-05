# clo835-asmt2-containerization-project
scp -i ~/.ssh/schoubeykey init_kind.sh kind.yaml install_httpd.sh 44.214.135.121:/tmp
scp -i ~/.ssh/schoubeykey pod-manifests/python-app.yaml pod-manifests/mysql-manual.yaml 44.214.135.121:/tmp
scp -i ~/.ssh/schoubeykey replicaset-manifests/mysql-rs.yaml replicaset-manifests/python-app-rs.yaml 44.214.135.121:/tmp
ssh -i ~/.ssh/schoubeykey 44.214.135.121
cd /tmp
chmod 777 init_kind.sh install_httpd.sh
./init_kind.sh
./install_httpd.sh
alias k=kubectl
k get pod mysql-pod -o yaml -n mysqlpod-namespace
k logs mysql-pod -n mysqlpod-namespace
k exec --stdin --tty mysql-pod -n mysqlpod-namespace -- /bin/bash
mysql -pdb_pass123
use employees
select * from employee;
k get pods -n mypythonpod-namespace
k logs my-python-app-pod -n mypythonpod-namespace
k port-forward my-python-app-pod -n mypythonpod-namespace 8080:8080
----In new Terminal-----
ssh -i ~/.ssh/schoubeykey 44.214.135.121
curl localhost:8080