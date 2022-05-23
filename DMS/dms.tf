#Creating a primary endpoint for DMS
resource "aws_dms_endpoint" "primary_endpoint" {
  endpoint_id   = "primary-endpoints-${var.name}"
  endpoint_type = "source"
  engine_name   = "mysql"
  username      = var.primary_db_username
  password      = var.primary_db_password
  port          = 3306
  server_name   = var.primary_rds_endpoint_key
  ssl_mode      = "none"
  tags          = merge(var.tags, { Name = "${var.name}-primary-rds-endpoint" })
  depends_on    = [aws_dms_replication_instance.dms-instance, aws_dms_replication_subnet_group.dms_subnet_group]
}

#Creating a secondary endpoint for DMS
resource "aws_dms_endpoint" "secondary_endpoint" {
  endpoint_id   = "secondary-endpoint-${var.name}"
  endpoint_type = "target"
  engine_name   = "mysql"
  username      = var.secondary_db_username
  password      = var.secondary_db_password
  port          = 3306
  server_name   = var.secondary_rds_endpoint_key
  ssl_mode      = "none"
  tags          = merge(var.tags, { Name = "${var.name}-secondary-rds-endpoint" })
}

#Creating a replication  instance for DMS
resource "aws_dms_replication_instance" "dms-instance" {
  allocated_storage          = var.replication_instance_storage
  apply_immediately          = true
  auto_minor_version_upgrade = false
  multi_az                   = false
  publicly_accessible        = var.replication_instance_publicly_accessible
  replication_instance_class = var.replication_instance_class
  replication_instance_id    = var.replication_instance_id
  engine_version             = var.replication_instance_engine_version

  vpc_security_group_ids = [
    aws_security_group.security_group_dms.id
  ]
  replication_subnet_group_id = aws_dms_replication_subnet_group.dms_subnet_group.replication_subnet_group_id

  tags = merge(var.tags, { Name = "${var.name}-replication-instance" })
}

# Create a new replication task for defining what type of migration we want and which tables we want to migrate
resource "aws_dms_replication_task" "dms-task" {
  migration_type           = var.migration_type
  replication_instance_arn = aws_dms_replication_instance.dms-instance.replication_instance_arn
  replication_task_id      = var.replication_task_id
  source_endpoint_arn      = aws_dms_endpoint.primary_endpoint.endpoint_arn
  table_mappings           = var.table_mappings
  target_endpoint_arn      = aws_dms_endpoint.secondary_endpoint.endpoint_arn
  tags                     = merge(var.tags, { Name = "${var.name}-replicatio-task" })

}

# Create a new replication subnet group
resource "aws_dms_replication_subnet_group" "dms_subnet_group" {
  replication_subnet_group_id          = var.replication_subnet_group_name
  replication_subnet_group_description = "DMS Replication subnet group"
  subnet_ids                           = var.replication_subnet_group_subnet_ids

  depends_on = [aws_iam_role_policy_attachment.dms-vpc-role-AmazonDMSVPCManagementRole]

  tags = merge(var.tags, { Name = "${var.name}-replication-subnet-group" })

}

resource "aws_security_group" "security_group_dms" {
  name        = "security_group_dms"
  description = "TCP/22"
  vpc_id      = var.vpc_id
  ingress {
    description = "Allow all traffic 3306 from our public IP"
    from_port   = 3306
    to_port     = 3306
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "null_resource" "start_replicating" {
  triggers = {
    dms_task_arn = aws_dms_replication_task.dms-task.replication_task_arn
    region       = var.region_primary
  }
  provisioner "local-exec" {
    when    = create
    command = "aws dms start-replication-task --start-replication-task-type start-replication --replication-task-arn ${self.triggers["dms_task_arn"]} --region ${self.triggers["region"]}"
  }

}
