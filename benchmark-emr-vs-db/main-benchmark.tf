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
  # region  = "us-east-2"
  # Just for fun... Sa~o Paulo
  region  = "sa-east-1"
}

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
  engine_version          = "8.0.mysql_aurora.3.02.0"
  # availability_zones      = ["us-east-2a", "us-east-2b", "us-east-2c"]
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
    # https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Aurora.AuroraMySQL.Compare-v2-v3.html#AuroraMySQL.mysql80-instance-classes
    #   db.t2.small is no longer acceptable.
    instance_class     = "db.t3"
    engine             = aws_rds_cluster.rds.engine
    engine_version     = aws_rds_cluster.rds.engine_version
    publicly_accessible = true 
  }


