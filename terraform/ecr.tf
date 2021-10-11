resource "aws_ecr_repository" "airflow_repo" {
  name = "airflow-repository-${terraform.workspace}"

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
