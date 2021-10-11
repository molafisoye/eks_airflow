
resource "aws_efs_file_system" "eks-efs" {
  creation_token   = "Airflow-on-EKS"
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = "true"

  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "AirflowVolume"
  }
}

resource "aws_efs_mount_target" "airflow_mount" {
  count           = 3
  file_system_id  = aws_efs_file_system.eks-efs.id
  subnet_id       = module.vpc.public_subnets[count.index]
  security_groups = [aws_security_group.allow_airflow_efs.id]
}

resource "aws_security_group" "allow_airflow_efs" {
  name        = "airflow-efs-sg"
  description = "Controlling traffic to and from airflow efs"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_efs_access_point" "efs-ap" {
  file_system_id = aws_efs_file_system.eks-efs.id

  posix_user {
    gid = 1000
    uid = 1000
  }

  root_directory {
    path = "/airflow"
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 777
    }
  }

  tags = {
    Name = "airflow-efs-ap"
  }
}