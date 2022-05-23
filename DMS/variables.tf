variable "name" {
  type        = string
  description = "The unique name of the DMS."
}

variable "region_primary" {
  type    = string
  description = "Region in which data migratin servive will deploy."
}

variable "primary_db_username" {
  description = "Specify primary rds database username."
  type        = string
}

variable "primary_db_password" {
  description = "Specify password for primary rds database."
  type        = string
}

variable "secondary_db_username" {
  description = "Specify secondary rds database username."
  type        = string
}

variable "secondary_db_password" {
  description = "Specify password for secondary rds database."
  type        = string
}

variable "vpc_id" {
  description = "VPC id for dms security group"
  type        = string
}

variable "replication_subnet_group_name" {
  type        = string
  description = "The name for the replication subnet group. Stored as a lowercase string, must contain no more than 255 alphanumeric characters, periods, spaces, underscores, or hyphens"
}

variable "replication_subnet_group_subnet_ids" {
  type        = list(string)
  default     = []
  description = "A list of the EC2 subnet IDs for the subnet group"
}

variable "primary_rds_endpoint_key" {
  description = "Host name of the primary rds server."
  type        = string
}

variable "secondary_rds_endpoint_key" {
  description = "Host name of the secondary rds server."
  type        = string
}

variable "replication_instance_id" {
  description = "The replication instance identifier. This parameter is stored as a lowercase string"
  type        = string
  default     = null
}

variable "replication_instance_class" {
  description = "The compute and memory capacity of the replication instance as specified by the replication instance class"
  type        = string
  default     = null
}

variable "replication_instance_engine_version" {
  description = "The engine version number of the replication instance."
  type        = string
  default     = null
}

variable "replication_instance_publicly_accessible" {
  description = "Specifies the accessibility options for the replication instance"
  type        = bool
  default     = null
}
# replication_task_id
variable "replication_task_id" {
  description = "The replication task identifier. This parameter is stored as a lowercase string"
  type        = string
  default     = null
}

variable "migration_type" {
  description = "The migration type. Can be one of full-load | cdc | full-load-and-cdc"
  type        = string
  default     = null
}

variable "replication_instance_storage" {
  description = "The amount of storage (in gigabytes) to be initially allocated for the replication instance. Min: 5, Max: 6144, Default: 50"
  type        = number
  default     = null
}



# variable "region_secondary" {
#   type    = string
#   default = "us-west-2"
# }

# variable "aws_profile" {
#   type    = string
#   default = "default"
# }
################################################################
# repl_subnet_group_subnet_ids  = ["subnet-1fe3d837", "subnet-129d66ab", "subnet-1211eef5"] #change



# replicationsubnet_group_name


# variable "subnet_1" {
#   type        = string
# }

# variable "subnet_2" {
#   type        = string
# }

##############

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags associated with the SNS topic."
}

# locals {
#   primary_rds_endpoint   = aws_db_instance.source_mysql_rds-1.address
#   secondary_rds_endpoint = aws_db_instance.target_mysql_rds-1.address
# }


