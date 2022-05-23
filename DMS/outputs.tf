output "database_migration_tasks_arn" {
  value = aws_dms_replication_task.dms-task.replication_task_arn
}

output "primary_rds_endpoint" {
  value = aws_dms_endpoint.primary_endpoint.endpoint_arn
}

output "secondary_rds_endpoint" {
  value = aws_dms_endpoint.secondary_endpoint.endpoint_arn
}
