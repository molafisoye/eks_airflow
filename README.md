#Airflow in EKS
This repo allows the creation of an apache airflow cluster in AWS EKS. The configuration creates the following resources -
* EKS cluster with spot instances to keep costs low and on demand instances to handle the webserver and scheduler.
* Am RDS PostgreSQL instance 
* All networking required to handle the cluster.
* An EFS mount to store all the data required by airflow.
* An ECR repo to store the containers containing DAGS

##Prerequisites 
* An AWS account with credentials on the local machine
* Terraform 1.0.8
* Linux shell - if on windows use git bash
* Docker 
* Kubernetes

##Instructions
1. Open the folder on th local machine
2. In the eks directory, run - 
   ```./run.sh {terraform workspace} {cluster-name} {region}```
3. Once the script is complete, run the floowing to log into the airflow webserver UI -
   ```./run.sh {terraform workspace} {cluster-name} {region}```
4. 