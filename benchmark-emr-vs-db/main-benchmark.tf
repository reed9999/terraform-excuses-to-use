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