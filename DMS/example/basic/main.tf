locals {
  name = "test-dms"
}
module "dms" {

  source = "../.."

  region_primary = "us-east-1"

  name = local.name

  primary_db_username = "admin"
  primary_db_password = "adminadmin"

  secondary_db_username = "admin"
  secondary_db_password = "adminadmin"

  vpc_id                     = module.vpc.vpc_id
  primary_rds_endpoint_key   = module.rds.primary_rds_endpoint
  secondary_rds_endpoint_key = module.rds.secondary_rds_endpoint

  replication_instance_id                  = "dms-instance-${local.name}"
  replication_instance_class               = "dms.t3.micro"
  replication_instance_engine_version      = "3.4.6"
  replication_instance_storage             = 10
  replication_instance_publicly_accessible = true

  replication_subnet_group_name = "${local.name}-replication-subnet-group"
  # at least two subnet within different Availability zone
  replication_subnet_group_subnet_ids = [module.vpc.aws_subnet_1, module.vpc.aws_subnet_2]

  replication_task_id = "${local.name}-replication-task-dms" #change
  migration_type      = "full-load-and-cdc"

  tags = {
    Name = "test"
  }
}


