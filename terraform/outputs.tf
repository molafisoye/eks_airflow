output "efs_aiflow_id" {
  value = aws_efs_file_system.eks-efs.id
}

output "airflow_efs_ap" {
  value = aws_efs_access_point.efs-ap.id
}

output "airflow_db_connection_string" {
  value = aws_db_instance.airflow-database.endpoint
}

output "airflow_ecr_repo" {
  value = aws_ecr_repository.airflow_repo.repository_url
}
