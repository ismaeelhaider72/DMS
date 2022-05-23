output "database_migration_tasks_arn" {
  value = module.dms.database_migration_tasks_arn
}

output "primary_rds_endpoint" {
  value = module.dms.primary_rds_endpoint
}

output "secondary_rds_endpoint" {
  value = module.rds.secondary_rds_endpoint
}
