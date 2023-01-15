terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-2"
}

# This is only a prototype-quality way of handling secrets
# It depends on env vars:
# ```
#  export TF_VAR_rds_username=...
#  export TF_VAR_rds_password=...
# Plan to read up on better ways to handle secrets.

variable "rds_username" {
  description = "The username for the RDS DB main user"
  type        = string
  sensitive   = true 
}
variable "rds_password" {
  description = "The password for the RDS DB main user"
  type        = string
  sensitive   = true 
}

resource "aws_rds_cluster" "rds" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-mysql"
  engine_version          = "5.7.mysql_aurora.2.10.2"
  availability_zones      = ["us-east-2a", "us-east-2b", "us-east-2c"]
  database_name           = "mydb"
  master_username         = var.rds_username
  master_password         = var.rds_password
  backup_retention_period = 5
  skip_final_snapshot     = true
  preferred_backup_window = "07:00-09:00"
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.rds.id
  # instance_class     = "db.r4.large"
  instance_class     = "db.t2.small"
  engine             = aws_rds_cluster.rds.engine
  engine_version     = aws_rds_cluster.rds.engine_version
  publicly_accessible = true 
}

# It seems the aws_db_instance below was never the right way to do this!

# See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance
# Note that a cluster without an instance will have endpoints that sit in "Creating" status forever,
# never accessible from a MYSQL client.
# resource "aws_db_instance" "db_instance" {
#     # Rather opaquely, omitting this defaults to "aurora" which is apparently a dummy setting.
#   # https://stackoverflow.com/a/70930027
#   # storage_type = "gp2"

#   allocated_storage    = 50
#   max_allocated_storage    = 200
#   engine               = "aurora-mysql"
#   engine_version       = "5.7.mysql_aurora.2.10.2"
#   # See https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html 
#   instance_class       = "db.t2.small"
#   db_name                 = "mydb"
#   username             = var.rds_username
#   password             = var.rds_password
#   parameter_group_name = "default.mysql5.7"
#   skip_final_snapshot  = true

# }

