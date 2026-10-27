variable "db_name" {
  description = "Name of the database created in the cluster"
  type        = string
  default     = "appdb"
}

# Newest Aurora PostgreSQL 17.x: from version 17, TLS connections are required by default
data "aws_rds_engine_version" "postgresql" {
  engine  = "aurora-postgresql"
  version = "17"
  latest  = true
}

resource "aws_rds_cluster" "app" {
  cluster_identifier = "secure-pipeline-aurora"
  engine             = "aurora-postgresql"
  engine_version     = data.aws_rds_engine_version.postgresql.version_actual
  database_name      = var.db_name
  master_username    = "dbadmin"

  manage_master_user_password         = true # RDS generates and rotates it in Secrets Manager; never in state
  iam_database_authentication_enabled = true
  storage_encrypted                   = true
  deletion_protection                 = true

  backup_retention_period         = 7
  copy_tags_to_snapshot           = true
  final_snapshot_identifier       = "secure-pipeline-aurora-final"
  enabled_cloudwatch_logs_exports = ["postgresql"]

  # Serverless v2 that pauses after 30 idle minutes, so an unused database costs nothing for compute
  serverlessv2_scaling_configuration {
    min_capacity             = 0
    max_capacity             = 2
    seconds_until_auto_pause = 1800
  }

  lifecycle {
    ignore_changes = [engine_version] # AWS applies minor upgrades automatically
  }
}

resource "aws_rds_cluster_instance" "app" {
  identifier                 = "secure-pipeline-aurora-1"
  cluster_identifier         = aws_rds_cluster.app.id
  engine                     = aws_rds_cluster.app.engine
  instance_class             = "db.serverless"
  publicly_accessible        = false
  auto_minor_version_upgrade = true
}


##
##
##