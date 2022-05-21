variable "name" {
  type        = string
  description = "Name for the AWS DMS."
}

variable "admin" {
  type        = string
  description = "Specify name for admin user."
}

variable "password" {
  type        = string
  description = "Specify passwoed for admin user."
}

variable "primary_rds_endpoint" {
  type        = string
  description = "Primary database endpoint identifier."
}

variable "secondary_rds_endpoint" {
  type        = string
  description = "Secondary database endpoint identifier."
}

variable "replication_instance_class" {
  type        = string
  description = "The compute and memory capacity of the replication instance as specified by the replication instance class"
  
}

variable "engine_version" {
  type        = string
  description = "The engine version number of the replication instance."
}

variable "migration_type" {
  type        = string
  description = "The migration type can be one of full-load | cdc | full-load-and-cdc."
}

variable "replication_instance_storage" {
  type        = number
  description = "The amount of storage (in gigabytes) to be allocated for the replication instance."
}

variable "region-primary" {
  type    = string
}

variable "replication_subnet_group_subnet_ids" {
  type        = list(string)
  description = "List of subnet ids for crearing subnet group in DMS."
}

variable "vpc_id" {
  type        = string
  description = "VPC id for dms security group ."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags associated with the DMS."
}


