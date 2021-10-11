#!/usr/bin/env bash

cd ./terraform

function exportEnvVars {
      export AOK_AIRFLOW_REPOSITORY=$(terraform output -raw airflow_ecr_repo)
      export AOK_EFS_FS_ID=$(terraform output -raw efs_aiflow_id)
      export AOK_EFS_AP=$(terraform output -raw airflow_efs_ap)
      export AOK_SQL_ALCHEMY_CONN="postgresql://airflow:password@$(terraform output -raw airflow_db_connection_string)/airflow"
}

terraform init
terraform workspace select $1 || terraform workspace new $1
terraform apply -var cluster_name=$2 -var region=$3 && exportEnvVars

cd ../docker

aws ecr get-login-password \
  --region $3 | \
  docker login \
  --username AWS \
  --password-stdin \
  $AOK_AIRFLOW_REPOSITORY

docker build -t $AOK_AIRFLOW_REPOSITORY .

if [ -z "$4" ]
then
      echo "no version specified will push container as [latest]"
      docker push "${AOK_AIRFLOW_REPOSITORY}:latest"
else
      echo "version specified will push container as [$4]"
      docker push "${AOK_AIRFLOW_REPOSITORY}:$2"
fi

./../kube/deploy.sh

echo "................................................................................."
echo ""
echo "................................................................................."
echo ""
echo "................................................................................."

echo "airflow web ui URL -"
echo "http://$(kubectl get service airflow -n airflow \
  -o jsonpath="{.status.loadBalancer.ingress[].hostname}"):8080\login"

echo "username - eksuser"
echo "password - ekspassword"
echo ""
echo "................................................................................."
echo "RESET THE ABOVE ONCE LOGGED IN"