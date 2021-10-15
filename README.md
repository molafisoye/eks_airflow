# Airflow in EKS
This repo allows the creation of an apache airflow cluster in AWS EKS. The configuration creates the following resources -
* EKS cluster with spot instances to keep costs low and on demand instances to handle the webserver and scheduler.
* Am RDS PostgreSQL instance 
* All networking required to handle the cluster.
* An EFS mount to store all the data required by airflow.
* An ECR repo to store the containers containing DAGS

## Prerequisites 
All of these can be installed either with chocolatey or via brew install.
* An AWS account with credentials on the local machine
* Terraform 1.0.8 ```brew install terraform```
* Linux shell - if on windows use git bash
* Docker ```brew install docker``` 
* Kubernetes ```brew install kubectl```
* Helm ```brew install helm```
* gnu-sed ```brew install gnu-sed```

## Instructions
1. Open the folder on the local machine
2. Start docker
3. In the eks directory, run - 
   ```./run.sh {terraform workspace} {cluster-name} {region}``` - replace the contents of the braces with the workspace, cluster name and region.
4. When prompted, if all the resources to be created look good then enter "yes"
5. Once the script is complete copy the output url and use the username and password details specified to log into your airflow cluster.

To integrate this into jenkins these scripts can be run in an automated fashion via the ./run.sh entry point.