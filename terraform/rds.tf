resource "aws_db_instance" "airflow-database" {
  identifier                = "airflow-database"
  allocated_storage         = 20
  engine                    = "postgres"
  engine_version            = "13.4"
  instance_class            = "db.t3.micro"
  name                      = "airflow"
  username                  = "airflow"
  password                  = "password"
  storage_type              = "gp2"
  backup_retention_period   = 14
  multi_az                  = false
  publicly_accessible       = true
  apply_immediately         = true
  db_subnet_group_name      = aws_db_subnet_group.airflow_subnetgroup.name
  final_snapshot_identifier = "ignore"
  skip_final_snapshot       = true
  vpc_security_group_ids    = [aws_security_group.allow_airflow_database.id]
  port                      = "5432"
}

resource "aws_db_subnet_group" "airflow_subnetgroup" {
  name        = "airflow-postgres-subnet"
  description = "airflow database subnet group"
  subnet_ids  = module.vpc.public_subnets
}

resource "aws_security_group" "allow_airflow_database" {
  name        = "allow_airflow_database"
  description = "Controlling traffic to and from airflows rds instance."
  vpc_id      = module.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

