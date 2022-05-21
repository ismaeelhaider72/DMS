#Creating a primary endpoint for DMS
resource "aws_dms_endpoint" "primary_endpoint" {
  endpoint_id   =  "primary-endpoints-${var.name}"  # var.primary_endpoint_identifier
  endpoint_type = "source"
  engine_name   = "mysql"
  password      = var.password
  port          = 3306
  server_name   =  local.primary_rds_endpoint # aws_db_instance.source_mysql_rds.address#"test-primary-database.cozzdxzyun2d.us-east-2.rds.amazonaws.com"#aws_instance.source_mysql.public_ip
  ssl_mode      = "none"
  username      = var.admin #"admin"
  tags = merge(var.tags, { Name = "${var.name}-primary-dms-endpoint" })
}

#Creating a secondary endpoint for DMS
resource "aws_dms_endpoint" "secondary_endpoint" {
  endpoint_id   = "secondary-endpoint-${var.name}"   #var.secondary_endpoint_identifier
  endpoint_type = "target"
  engine_name   = "mysql"
  password      = var.password
  port          = 3306
  server_name   =  local.secondary_rds_endpoint # aws_db_instance.source_mysql_rds.address#"test-primary-database.cozzdxzyun2d.us-east-2.rds.amazonaws.com"#aws_instance.source_mysql.public_ip
  ssl_mode      = "none"
  username      = var.admin #"admin"
  tags =  merge(var.tags, { Name= "${var.name}-secondary-dms-endpoint" })
}

#Creating a replication instance for DMS
resource "aws_dms_replication_instance" "dms-instance" {
  allocated_storage          = var.replication_instance_storage
  apply_immediately          = true
  auto_minor_version_upgrade = false
  multi_az                   = false
  publicly_accessible        = true
  replication_instance_class = var.replication_instance_class #"dms.t3.large"
  replication_instance_id    = "dms-instance-${var.name}"   #var.replication_instance_id #"dms-instance"
  engine_version             = var.engine_version #"3.4.6"

  vpc_security_group_ids = [
    aws_security_group.security_group_dms.id
  ]
  replication_subnet_group_id  =  aws_dms_replication_subnet_group.subnet_group.replication_subnet_group_id  

  depends_on = [aws_iam_role.dms-vpc-role]
  tags =  merge(var.tags, { Name = "${var.name}-dms-replication-instance"})
}

# Create a new replication task for defining what type of migration we want and which tables we want to migrate
resource "aws_dms_replication_task" "dms-task" {  
  migration_type           = var.migration_type  
  replication_instance_arn = aws_dms_replication_instance.dms-instance.replication_instance_arn
  replication_task_id      = "${var.name}-replication-task-dms" 
  source_endpoint_arn      = aws_dms_endpoint.primary_endpoint.endpoint_arn
  table_mappings           = file("${path.module}/table_mappings.json")
  target_endpoint_arn      = aws_dms_endpoint.secondary_endpoint.endpoint_arn
  tags =  merge(var.tags, { Name = "${var.name}-dms-replicatio-task"  })
}

# Create a new replication subnet group
resource "aws_dms_replication_subnet_group" "subnet_group" {
  replication_subnet_group_description = "DMS Replication subnet group"
  replication_subnet_group_id          = "${var.name}-dms-replication-subnet-group"

  subnet_ids = var.replication_subnet_group_subnet_ids 

  tags = merge(var.tags, { Name  = "${var.name}-dms-replication-subnet-group" })
  
}


resource "aws_security_group" "security_group_dms" {
  name        = "security_group_dms"
  description = "TCP/22"
  vpc_id      = var.vpc_id 
  ingress {
    description = "allow anyone on port 3306"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    self        = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

# start replication task after creates
resource "null_resource" "start_replicating" {
  triggers = {
    dms_task_arn = aws_dms_replication_task.dms-task.replication_task_arn
  }
  provisioner "local-exec" {
    when    = create
    command = "aws dms start-replication-task --start-replication-task-type start-replication --replication-task-arn ${self.triggers["dms_task_arn"]}"
  }

}
